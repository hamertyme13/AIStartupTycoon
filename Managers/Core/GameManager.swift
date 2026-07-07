import Foundation
import Observation

enum GameOutcome: Identifiable {

    case victory(String)
    case failure(String)

    var id: String {

        switch self {

        case .victory(let message):
            return "victory-\(message)"

        case .failure(let message):
            return "failure-\(message)"

        }

    }

    var title: String {

        switch self {

        case .victory:
            return "Victory"

        case .failure:
            return "Company Failed"

        }

    }

    var message: String {

        switch self {

        case .victory(let message),
             .failure(let message):
            return message

        }

    }

}

@Observable
class GameManager {

    // MARK: - Game State

    var company = Company()

    var secondsElapsed = 0

    var currentEvent: GameEvent?

    var latestReport: MonthlyReport?

    var gameOutcome: GameOutcome?
    
    init() {
        refreshTalentMarket()
    }

    // MARK: - Time
    
    var gameSpeed: GameSpeed = .normal
    
    var secondsPerMonth: Int {
        
        gameSpeed.secondsPerMonth
        
    }
    
    // MARK: - Notifications

    internal func addNotification(title: String, message: String) {

        company.latestNews = message

        let notification = CompanyNotification(
            title: title,
            message: message,
            year: company.currentYear,
            month: company.currentMonth
        )

        company.notifications.insert(notification, at: 0)

    }

    // MARK: - Game Loop

    func tick() {

        addCash(company.monthlyRevenue / 30)

    }
    
    func advanceOneSecond() {

        tick()

        // Employees
        employeeWork()
        employeeResearch()
        awardEmployeeExperience()
        checkEmployeePromotions()

        // Products
        growProducts()

        // AI
        updateModelTraining()

    }

    // MARK: - Products

    func buildProduct(index: Int) {

        guard company.products.indices.contains(index) else { return }

        guard company.products[index].unlocked else {

            addNotification(
                title: "🔒 Locked",
                message: "Product is still locked."
            )

            return

        }

        let cost = company.products[index].buildCost

        guard spendCash(cost) else {
            
            addNotification(
                title: "❌ Not Enough Cash",
                message: "You need more money to build this product."
            )
            
            return
        }

        company.products[index].level += 1

        company.products[index].customers += 100

        company.monthlyRevenue +=
            company.products[index].revenuePerLevel

        company.companyValue +=
            company.products[index].revenuePerLevel * 5

        changeMarketShare(by: 0.5)

        addNotification(
            title: "🚀 Product Upgrade",
            message: "\(company.products[index].name) reached Level \(company.products[index].level)"
        )

        unlockProducts()

    }

    private func unlockProducts() {

        for index in company.products.indices {

            guard !company.products[index].unlocked else {

                continue

            }

            guard technologyUnlocked(
                company.products[index].requiredTechnology
            ) else {

                continue

            }

            switch index {

            case 1:

                if company.products[0].level >= 5 {

                    company.products[index].unlocked = true

                    addNotification(
                        title: "🔓 Product Unlocked",
                        message:
                            "\(company.products[index].name) is now available."
                    )

                }

            case 2:

                if company.products[1].level >= 5 {

                    company.products[index].unlocked = true

                    addNotification(
                        title: "🔓 Product Unlocked",
                        message:
                            "\(company.products[index].name) is now available."
                    )

                }

            case 3:

                if company.products[2].level >= 5 {

                    company.products[index].unlocked = true

                    addNotification(
                        title: "🔓 Product Unlocked",
                        message:
                            "\(company.products[index].name) is now available."
                    )

                }

            default:

                break

            }

        }

    }
    

    func growProducts() {

        let productBonus = 1 +
            Double(company.employees.filter {
                $0.department == .product
            }.count) * 0.05

        let growthBonus = 1 +
            Double(company.employees.filter {
                $0.department == .growth
            }.count) * 0.08

        for index in company.products.indices {

            guard company.products[index].unlocked else { continue }

            let growth = Double(company.products[index].dailyGrowth)

            let bonus = growth * (Double(company.reputation) / 100)

            company.products[index].customers +=
                Int((growth + bonus) * productBonus * growthBonus)

        }

    }

    // MARK: - Employees
    
    func hire(_ candidate: Candidate) {

        guard company.cash >= candidate.salary else {

            addNotification(
                title: "Not Enough Cash",
                message: "You can't afford to hire \(candidate.name)."
            )

            return

        }

        var employee = Employee(

            name: candidate.name,

            role: candidate.role,

            salary: candidate.salary,

            skill: candidate.skill,
            
            specialty: candidate.specialty,
            
            potential: candidate.potential

        )
        
        employee.experience = Double(candidate.skill)

        switch candidate.role {

        case .researchAssistant,
             .researchScientist,
             .seniorScientist,
             .principalScientist,
             .chiefScientist:
            employee.department = .research

        case .productManager:
            employee.department = .product

        default:
            employee.department = .engineering

        }

        company.employees.append(employee)

        company.talentMarket.removeAll {

            $0.id == candidate.id

        }

        addNotification(

            title: "New Hire",

            message: "\(candidate.name) joined the company!"

        )
        
        company.latestNews =
        """
        🎉 \(candidate.name) joined the company!

        Role:
        \(candidate.role.rawValue)

        Specialty:
        \(candidate.specialty)
        """

    }

    func assignEmployee(
        at index: Int,
        to department: EmployeeDepartment
    ) {

        guard company.employees.indices.contains(index) else {

            return

        }

        company.employees[index].department = department

        addNotification(
            title: "Department Updated",
            message:
                "\(company.employees[index].name) moved to \(department.rawValue)."
        )

    }

    func employeeWork() {

        let revenueGain = company.employees.reduce(0) { total, employee in

            let productivity =
                employee.productivity *
                (1 + company.currentOffice.productivityBonus)

            return total + (productivity * 5)

        }

        addCash(revenueGain)

    }
    
    func updateEmployees() {

        for index in company.employees.indices {

            company.employees[index].experience += 1

            if company.employees[index].experience >=
                company.employees[index].experienceNeeded {

                company.employees[index].experience = 0

                company.employees[index].level += 1

                company.employees[index].skill += 2

                addNotification(
                    title: "📈 Level Up",
                    message:
                        "\(company.employees[index].name) reached Level \(company.employees[index].level)"
                )

            }
            
            if company.employees[index].level >= 5 &&
               company.employees[index].role == .juniorEngineer {

                company.employees[index].role = .seniorEngineer

                company.employees[index].skill += 5

                company.employees[index].salary += 1500

                addNotification(
                    title: "🎉 Promotion",
                    message: "\(company.employees[index].name) was promoted to Senior Engineer!"
                )

            }

        }

    }
    
    func promoteEmployee(at index: Int) {

        var employee = company.employees[index]

        switch employee.role {

        case .juniorEngineer:
            employee.role = .engineer

        case .engineer:
            employee.role = .seniorEngineer

        case .seniorEngineer:
            employee.role = .staffEngineer

        case .staffEngineer:
            employee.role = .principalEngineer

        case .principalEngineer:
            employee.role = .distinguishedEngineer

        case .researchAssistant:
            employee.role = .researchScientist

        case .researchScientist:
            employee.role = .seniorScientist

        case .seniorScientist:
            employee.role = .principalScientist

        case .principalScientist:
            employee.role = .chiefScientist

        case .distinguishedEngineer,
             .chiefScientist,
             .productManager:
            return
        }

        employee.level += 1
        
        let skillGain: Int

        switch employee.potential {

        case 95...100:
            skillGain = 7

        case 85..<95:
            skillGain = 6

        case 75..<85:
            skillGain = 5

        case 65..<75:
            skillGain = 4

        default:
            skillGain = 3

        }

        employee.skill += skillGain
        employee.salary += Double(skillGain * 300)

        employee.experience = 0

        company.employees[index] = employee

        addNotification(
            title: "🎉 Promotion",
            message:
        """
        \(employee.name) is now a \(employee.role.rawValue)!

        +\(skillGain) Skill
        +$\(Int(Double(skillGain * 300))) Salary
        """
        )

    }
    
    func awardEmployeeExperience() {

        for index in company.employees.indices {

            company.employees[index].experience +=
                company.employees[index].productivity

        }

    }
    
    func checkEmployeePromotions() {

        for index in company.employees.indices {

            if company.employees[index].experience >=
                company.employees[index].experienceNeeded {

                promoteEmployee(at: index)

            }

        }

    }

    // MARK: - Research

    func addResearchPoints(_ amount: Double) {

        company.researchPoints += amount

    }
    
    func startResearch(index: Int) {

        guard company.technologies.indices.contains(index) else {

            return

        }

        guard !company.technologies[index].unlocked else {

            return

        }

        company.activeResearch = company.technologies[index].id

        addNotification(
            title: "🧠 Research Started",
            message: company.technologies[index].name
        )

    }
    
    func updateResearch() {

        guard let activeID = company.activeResearch else {

            return

        }

        guard let index = company.technologies.firstIndex(where: {

            $0.id == activeID

        }) else {

            return

        }

        company.technologies[index].progress += 1

        if company.technologies[index].progress >=
            company.technologies[index].requiredResearch {

            company.technologies[index].unlocked = true

            company.activeResearch = nil

            addNotification(
                title: "🔬 Research Complete",
                message: "\(company.technologies[index].name) unlocked!"
            )

            unlockProducts()

        }

    }
    
    func employeeResearch() {

        guard let activeID = company.activeResearch else {

            return

        }

        guard let index = company.technologies.firstIndex(where: {

            $0.id == activeID

        }) else {

            return

        }

        let researchGain = company.employees.reduce(0.0) { total, employee in

            let researchPower =
                employee.researchOutput *
                (1 + company.currentOffice.researchBonus)

            return total + researchPower

        }

        company.researchPoints += researchGain

        company.technologies[index].progress += researchGain

        if company.technologies[index].progress >=
            company.technologies[index].requiredResearch {

            company.technologies[index].progress =
                company.technologies[index].requiredResearch

            company.technologies[index].unlocked = true

            company.activeResearch = nil

            changeMarketShare(by: 1)

            addNotification(
                title: "🧠 Research Complete",
                message:
                    "\(company.technologies[index].name) unlocked!"
            )

            unlockProducts()
            updateAIModelAvailability()

        }

    }
    
    func updateAIModelAvailability() {

        for index in company.aiModels.indices {

            guard company.aiModels[index].status == .locked else {

                continue

            }

            if company.hasUnlockedTechnology(
                company.aiModels[index].requiredTechnology
            ) {

                company.aiModels[index].status = .readyToTrain

                addNotification(
                    title: "🤖 AI Model Available",
                    message: "\(company.aiModels[index].name) is ready to train!"
                )

            }

        }

    }
    
    func beginTraining(modelID: UUID) {

        guard let index = company.aiModels.firstIndex(where: {
            $0.id == modelID
        }) else {

            return

        }

        guard company.cash >= company.aiModels[index].trainingCost else {

            addNotification(
                title: "Insufficient Funds",
                message: "Not enough cash to begin training."
            )

            return

        }

        company.cash -= company.aiModels[index].trainingCost

        company.aiModels[index].status = .training

        company.aiModels[index].trainingProgress = 0

        addNotification(
            title: "Training Started",
            message: "\(company.aiModels[index].name) is now training."
        )

    }
    
    func updateModelTraining() {

        for index in company.aiModels.indices {

            guard company.aiModels[index].status == .training else {

                continue

            }

            let researchPower = company.employees.reduce(0.0) {

                $0 + $1.researchOutput

            }

            let officeBonus =
                company.currentOffice.researchBonus

            company.aiModels[index].trainingProgress +=
                researchPower * (1 + officeBonus)

            if company.aiModels[index].trainingProgress >= 100 {

                company.aiModels[index].trainingProgress = 100

                company.aiModels[index].status = .readyToRelease

                addNotification(
                    title: "Training Complete",
                    message: "\(company.aiModels[index].name) is ready to launch!"
                )

            }

        }

    }
    
    func releaseModel(modelID: UUID) {

        guard let index = company.aiModels.firstIndex(where: {
            $0.id == modelID
        }) else {

            return

        }

        guard company.aiModels[index].status == .readyToRelease else {

            return

        }

        let model = company.aiModels[index]

        company.monthlyRevenue += model.revenueBonus

        company.companyValue += model.valuationBonus

        changeMarketShare(by: model.marketShareBonus)

        company.aiModels[index].status = .released

        addNotification(
            title: "🚀 Model Released",
            message: "\(model.name) launched successfully!"
        )
        
        company.latestNews =
        """
        🚀 \(model.name) launches worldwide!

        Revenue +$\(Int(model.revenueBonus))

        Market Share +\(Int(model.marketShareBonus))%

        Valuation +$\(Int(model.valuationBonus).formatted())
        """

    }

    // MARK: - Investors

    func acceptInvestment(index: Int) {

        guard company.investors.indices.contains(index) else { return }

        guard !company.investors[index].invested else {

            addNotification(
                title: "⚠️ Investor",
                message: "This investor has already invested."
            )

            return

        }

        addCash(company.investors[index].investment)

        company.founderOwnership -=
            company.investors[index].equity

        company.investors[index].invested = true

        company.investors[index].investedDate =
            "Year \(company.currentYear) • Month \(company.currentMonth)"
        
        company.activeInvestors.append(
            company.investors[index]
        )
        
        addNotification(
            title: "💰 Seed Funding",
            message:
        """
        \(company.investors[index].name)

        Invested $\(Int(company.investors[index].investment).formatted())

        Founder Ownership:
        \(Int(company.founderOwnership))%
        """
        )

    }

    // MARK: - Monthly Simulation

    func nextMonth() {

        guard gameOutcome == nil else { return }

        processMonthlyFinances()

        createMonthlyReport()

        advanceCalendar()
        
        refreshTalentMarket()
        
        company.latestNews = NewsManager.randomHeadline(
            competitors: company.competitors
        )

        rollForEvent()
        
        simulateCompetitors()
        
        generateCEOBriefing()

        evaluateGameOutcome()

    }
    
    private func refreshTalentMarket() {

        company.talentMarket.removeAll()

        for _ in 0..<3 {

            company.talentMarket.append(
                HiringManager.generateCandidate()
            )

        }

    }

    private func processMonthlyFinances() {

        addCash(company.monthlyProfit)

    }

    private func createMonthlyReport() {

        let payroll = company.employees.reduce(0) {

            $0 + $1.salary

        }

        latestReport = MonthlyReport(

            month: company.currentMonth,
            year: company.currentYear,

            revenue: company.monthlyRevenue,

            payroll: payroll,

            officeRent: company.currentOffice.monthlyRent,

            serverCost: company.serverCost,

            researchCost: company.researchExpense,

            endingCash: company.cash

        )

        addNotification(
            title: "📊 Monthly Report",
            message: "Month closed with \(company.monthlyProfit >= 0 ? "a profit" : "a loss")."
        )

    }

    private func advanceCalendar() {

        company.currentMonth += 1

        if company.currentMonth > 12 {

            company.currentMonth = 1
            company.currentYear += 1

        }

        addNotification(
            title: "📅 New Month",
            message: "Year \(company.currentYear) • Month \(company.currentMonth)"
        )

    }

    // MARK: - Competitors

    func updateCompetitors() {

        simulateCompetitors()

    }

    // MARK: - Events

    func rollForEvent() {

        guard Int.random(in: 1...100) <= 20 else {

            return

        }

        currentEvent = EventManager.events.randomElement()

    }

    func apply(
        _ option: GameEventOption,
        from event: GameEvent
    ) {

        addCash(option.cashEffect)

        company.companyValue += option.companyValueEffect

        company.researchPoints =
            max(0, company.researchPoints + option.researchEffect)

        company.reputation =
            min(100, max(0, company.reputation + option.reputationEffect))

        changeMarketShare(by: option.marketShareEffect)

        if let first = company.products.indices.first {

            company.products[first].customers +=
                option.customerEffect

            company.products[first].customers =
                max(0, company.products[first].customers)

        }

        addNotification(
            title: event.title,
            message: option.title
        )

        currentEvent = nil

        evaluateGameOutcome()

    }
    // MARK: - Economy Helpers

    @discardableResult
    private func spendCash(_ amount: Double) -> Bool {

        guard company.cash >= amount else {

            return false

        }

        company.cash -= amount

        return true

    }

    private func addCash(_ amount: Double) {

        company.cash += amount

    }

    private func technologyUnlocked(_ technology: String?) -> Bool {

        guard let technology else {

            return true

        }

        return company.technologies.contains {

            $0.name == technology && $0.unlocked

        }

    }
    private func canAfford(_ amount: Double) -> Bool {

        company.cash >= amount

    }

    // MARK: - Market

    private func changeMarketShare(by amount: Double) {

        company.marketShare += amount

        company.marketShare = min(
            max(company.marketShare, 1),
            95
        )

}
    
    // MARK: - Marketing

    func launchMarketingCampaign() {

        let cost = 2000.0

        guard company.cash >= cost else {

            addNotification(
                title: "❌ Marketing Failed",
                message: "Not enough cash for a marketing campaign."
            )

            return
        }

        guard spendCash(cost) else {

            addNotification(
                title: "❌ Marketing Failed",
                message: "Not enough cash for a marketing campaign."
            )

            return

        }

        company.reputation += 2

        changeMarketShare(by: 1.0)

        let customers = Int.random(in: 300...700)

        if let first = company.products.indices.first {

            company.products[first].customers += customers

        }

        addNotification(
            title: "📢 Marketing Campaign",
            message: "Campaign attracted \(customers) new customers."
        )

    }
    
    func skipToNextMonth() {

        guard gameOutcome == nil else { return }

        while secondsElapsed < secondsPerMonth {

            advanceOneSecond()

            secondsElapsed += 1

        }

        secondsElapsed = 0

        nextMonth()

    }

    func evaluateGameOutcome() {

        guard gameOutcome == nil else { return }

        if company.cash < -25_000 {

            gameSpeed = .paused

            gameOutcome = .failure(
                "Your startup ran out of cash and could not cover its obligations."
            )

            addNotification(
                title: "Company Failed",
                message: "Your startup ran out of cash."
            )

            return

        }

        if company.founderOwnership < 20 {

            gameSpeed = .paused

            gameOutcome = .failure(
                "You diluted below 20% ownership and lost control of the company."
            )

            addNotification(
                title: "Founder Control Lost",
                message: "Founder ownership fell below 20%."
            )

            return

        }

        if company.hasUnlockedTechnology("Artificial General Intelligence") &&
           company.companyValue >= 100_000_000 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "You built a $100M AGI company and became the defining startup of the era."
            )

            addNotification(
                title: "Victory",
                message: "Your company reached AGI and a $100M valuation."
            )

            return

        }

        if company.marketShare >= 60 &&
           company.monthlyRevenue >= 100_000 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "You captured the AI market with dominant share and serious revenue."
            )

            addNotification(
                title: "Market Dominance",
                message: "Your startup now leads the AI industry."
            )

        }

    }
    
    func upgradeOffice() {

        guard company.officeLevel < company.offices.count - 1 else {

            addNotification(
                title: "🏢 Headquarters",
                message: "You already own the best office!"
            )

            return
        }

        let nextOffice = company.offices[company.officeLevel + 1]

        guard company.cash >= nextOffice.cost else {

            addNotification(
                title: "💸 Not Enough Cash",
                message: "You need $\(Int(nextOffice.cost).formatted()) to upgrade."
            )

            return
        }

        company.cash -= nextOffice.cost

        company.officeLevel += 1

        company.reputation += nextOffice.reputationBonus

        addNotification(
            title: "🏢 Office Upgraded",
            message: "Your company moved into the \(nextOffice.name)!"
        )

    }
    
    

}
