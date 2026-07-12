import Foundation
import Observation

enum GameOutcome: Identifiable, Codable {

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

    var icon: String {

        switch self {

        case .victory(let message):
            if message.contains("IPO") {
                return "chart.line.uptrend.xyaxis.circle.fill"
            }

            if message.contains("acquired") ||
               message.contains("acquisition") {
                return "building.2.crop.circle.fill"
            }

            if message.contains("AGI") {
                return "sparkles"
            }

            return "trophy.fill"

        case .failure:
            return "exclamationmark.triangle.fill"

        }

    }

    var primaryActionTitle: String {

        switch self {

        case .victory:
            return "Review Legacy"

        case .failure:
            return "Review Company"

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

    var hasStartedGame = false

    var showNewGameSetup = false

    var openingSceneTrigger = 0

    var lastChurnedCustomers = 0
    
    init() {

        if let save = SaveManager.load() {

            company = save.company.restoreCompany()
            secondsElapsed = save.secondsElapsed
            gameSpeed = save.gameSpeed
            gameOutcome = save.gameOutcome
            hasStartedGame = save.hasStartedGame
            showNewGameSetup = !save.hasStartedGame

        } else {

            showNewGameSetup = true
            refreshTalentMarket()

        }

        generateCEOBriefing()

    }

    // MARK: - Time
    
    var gameSpeed: GameSpeed = .normal
    
    var secondsPerMonth: Int {
        
        gameSpeed.secondsPerMonth
        
    }

    func startNewGame(
        scenario: Company.Scenario,
        playerName: String,
        companyName: String
    ) {

        company = Company()
        company.playerName =
            playerName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            ? "Founder"
            : playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        company.name =
            companyName.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
            ? "Rogue AI Labs"
            : companyName.trimmingCharacters(in: .whitespacesAndNewlines)
        company.selectedScenario = scenario
        company.cash = scenario.startingCash
        company.founderOwnership = scenario.startingOwnership
        company.reputation = scenario.startingReputation
        company.customerGrowthMultiplier = scenario.demandMultiplier

        switch scenario {

        case .vcRocketShip:
            company.companyValue = 250_000
            company.monthlyRevenue = 600

        case .aiWinter:
            company.monthlyRevenue = 150
            company.customerSatisfaction = 72

        case .openSourceWar:
            company.marketShare = 55
            company.competitors[0].marketShare += 5
            company.competitors[1].marketShare += 5

        case .bootstrappedFounder:
            break

        }

        secondsElapsed = 0
        gameSpeed = .paused
        currentEvent = nil
        latestReport = nil
        gameOutcome = nil
        hasStartedGame = true
        showNewGameSetup = false
        openingSceneTrigger += 1

        refreshTalentMarket()
        refreshContractOpportunities()
        generateCEOBriefing()
        saveGame()

    }

    func resetGame() {

        SaveManager.deleteSave()
        company = Company()
        secondsElapsed = 0
        gameSpeed = .paused
        currentEvent = nil
        latestReport = nil
        gameOutcome = nil
        hasStartedGame = false
        showNewGameSetup = true
        refreshTalentMarket()
        refreshContractOpportunities()
        generateCEOBriefing()

    }

    func saveGame() {

        SaveManager.save(
            SaveManager.SaveData(
                company: SaveManager.CompanySnapshot(company: company),
                secondsElapsed: secondsElapsed,
                gameSpeed: gameSpeed,
                gameOutcome: gameOutcome,
                hasStartedGame: hasStartedGame
            )
        )

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

        company.completedTutorialSteps.insert("firstProduct")

        company.products[index].customers += 100

        company.monthlyRevenue +=
            company.products[index].revenuePerLevel *
            company.products[index].strategy.revenueMultiplier

        company.companyValue +=
            company.products[index].revenuePerLevel * 5

        changeMarketShare(by: 0.5)

        addNotification(
            title: "🚀 Product Upgrade",
            message: "\(company.products[index].name) reached Level \(company.products[index].level)"
        )

        unlockProducts()

        saveGame()

    }

    func setProductStrategy(
        index: Int,
        strategy: ProductStrategy
    ) {

        guard company.products.indices.contains(index) else { return }

        company.products[index].strategy = strategy

        addNotification(
            title: "Product Strategy Updated",
            message: "\(company.products[index].name) is now focused on \(strategy.rawValue)."
        )

        saveGame()

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

        let demandMultiplier =
            company.customerGrowthMultiplier *
            (company.activeWorldEvent?.demandMultiplier ?? 1)

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
                Int(
                    (growth + bonus) *
                    productBonus *
                    growthBonus *
                    demandMultiplier
                )

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

            gender: candidate.gender,

            role: candidate.role,

            careerPath: candidate.careerPath,

            salary: candidate.salary,

            skill: candidate.skill,
            
            specialty: candidate.specialty,
            
            potential: candidate.potential,

            avatar: candidate.avatar

        )
        
        employee.experience = Double(candidate.skill)
        employee.department = candidate.careerPath.defaultDepartment

        company.employees.append(employee)

        company.completedTutorialSteps.insert("firstHire")

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
        \(candidate.careerPath.title(for: 1))

        Specialty:
        \(candidate.specialty)
        """

        saveGame()

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

        saveGame()

    }

    func fireEmployee(at index: Int) {

        guard company.employees.indices.contains(index) else { return }

        guard company.employees[index].name != "You" else {

            addNotification(
                title: "Founder Required",
                message: "You cannot fire the founder."
            )

            return

        }

        let employee = company.employees.remove(at: index)

        for remainingIndex in company.employees.indices {

            company.employees[remainingIndex].morale =
                max(0, company.employees[remainingIndex].morale - 4)
            company.employees[remainingIndex].loyalty =
                max(0, company.employees[remainingIndex].loyalty - 3)

        }

        addNotification(
            title: "Employee Fired",
            message: "\(employee.name) left the company. The remaining team is watching leadership closely."
        )

        saveGame()

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
            
        }

    }
    
    func promoteEmployee(at index: Int) {

        var employee = company.employees[index]

        guard employee.level < 8 else {

            employee.experience = employee.experienceNeeded
            company.employees[index] = employee

            return

        }

        employee.level += 1
        employee.role = employee.careerPath.role(for: employee.level)
        
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
        \(employee.name) is now a \(employee.careerTitle)!

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

        company.researchExpense =
            company.technologies[index].monthlyResearchCost

        company.completedTutorialSteps.insert("firstResearch")

        addNotification(
            title: "🧠 Research Started",
            message:
                "\(company.technologies[index].name) will cost $\(Int(company.researchExpense))/mo."
        )

        saveGame()

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

            company.researchExpense = 0

            addNotification(
                title: "🔬 Research Complete",
                message: "\(company.technologies[index].name) unlocked!"
            )

            unlockProducts()

        }

    }
    
    func employeeResearch() {

        guard let activeID = company.activeResearch else {

            company.researchExpense = 0

            return

        }

        guard let index = company.technologies.firstIndex(where: {

            $0.id == activeID

        }) else {

            company.activeResearch = nil
            company.researchExpense = 0

            return

        }

        company.researchExpense =
            company.technologies[index].monthlyResearchCost

        let researchGain = company.employees.reduce(0.0) { total, employee in

            let researchPower =
                employee.researchOutput *
                (1 + company.currentOffice.researchBonus) *
                (company.activeWorldEvent?.researchMultiplier ?? 1)

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

            company.researchExpense = 0

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

        saveGame()

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

        saveGame()

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

        let investor = company.investors[index]
        let contribution = investor.contribution

        addCash(investor.investment)

        company.founderOwnership -=
            investor.equity

        company.companyValue += contribution.valuationBonus
        company.monthlyRevenue += contribution.monthlyRevenueBoost
        company.researchPoints += contribution.researchPointGrant
        company.customerGrowthMultiplier += contribution.customerGrowthBonus
        company.reputation =
            min(100, company.reputation + contribution.reputationBonus)

        changeMarketShare(by: contribution.marketShareBonus)

        company.investors[index].invested = true

        company.investors[index].investedDate =
            "Year \(company.currentYear) • Month \(company.currentMonth)"
        
        company.activeInvestors.append(
            company.investors[index]
        )

        if contribution.candidateBoost > 0 {

            for _ in 0..<contribution.candidateBoost {

                company.talentMarket.append(
                    HiringManager.generateCandidate()
                )

            }

        }

        company.completedTutorialSteps.insert("firstInvestment")
        
        addNotification(
            title: "💰 Seed Funding",
            message:
        """
        \(company.investors[index].name)

        Invested $\(Int(investor.investment).formatted())

        Contribution:
        \(contribution.title)

        Founder Ownership:
        \(Int(company.founderOwnership))%
        """
        )

        saveGame()

    }

    // MARK: - Monthly Simulation

    func nextMonth() {

        guard gameOutcome == nil else { return }

        updateWorldEvent()

        lastChurnedCustomers = processCustomerChurn()

        processMonthlyFinances()

        createMonthlyReport()

        advanceCalendar()
        
        refreshTalentMarket()

        refreshContractOpportunities()
        
        company.latestNews = NewsManager.monthlyHeadline(
            for: company
        )

        rollForEvent()
        
        simulateCompetitors()

        processMonthlyPulse()

        processEmployeeMoraleAndPoaching()

        processInvestorRelationships()

        evaluateAchievements()
        
        generateCEOBriefing()

        evaluateGameOutcome()

        saveGame()

    }
    
    private func refreshTalentMarket() {

        company.talentMarket.removeAll()

        for _ in 0..<3 {

            company.talentMarket.append(
                HiringManager.generateCandidate()
            )

        }

    }

    private func refreshContractOpportunities() {

        var contracts: [Company.ContractOpportunity] = [
            Company.ContractOpportunity(
                name: "Customer Support Automation",
                kind: .contract,
                payout: 8_000,
                reputationEffect: 1,
                satisfactionEffect: 2,
                researchEffect: 20,
                durationMonths: 1
            ),
            Company.ContractOpportunity(
                name: "Enterprise Knowledge Bot Pilot",
                kind: .enterprisePilot,
                payout: 28_000,
                reputationEffect: 2,
                satisfactionEffect: -1,
                researchEffect: 35,
                durationMonths: 2
            ),
            Company.ContractOpportunity(
                name: "Responsible AI Grant",
                kind: .governmentGrant,
                payout: 18_000,
                reputationEffect: 3,
                satisfactionEffect: 0,
                researchEffect: 80,
                durationMonths: 3
            ),
            Company.ContractOpportunity(
                name: "Internal Copilot Rollout",
                kind: .enterprisePilot,
                payout: 42_000,
                reputationEffect: 2,
                satisfactionEffect: -2,
                researchEffect: 50,
                durationMonths: 2
            )
        ]

        contracts.shuffle()
        company.availableContracts = Array(contracts.prefix(3))

    }

    func acceptContract(
        id: UUID
    ) {

        guard let index = company.availableContracts.firstIndex(where: {
            $0.id == id
        }) else {
            return
        }

        let contract = company.availableContracts.remove(at: index)

        addCash(contract.payout)
        company.reputation =
            min(100, max(0, company.reputation + contract.reputationEffect))
        company.customerSatisfaction =
            min(
                100,
                max(0, company.customerSatisfaction + contract.satisfactionEffect)
            )
        company.researchPoints += contract.researchEffect
        company.completedContracts += 1

        for employeeIndex in company.employees.indices {
            company.employees[employeeIndex].burnout =
                min(100, company.employees[employeeIndex].burnout + 4)
            company.employees[employeeIndex].morale =
                max(0, company.employees[employeeIndex].morale - 1)
        }

        addNotification(
            title: "\(contract.kind.rawValue) Completed",
            message: "\(contract.name) paid $\(Int(contract.payout).formatted()) but added pressure to the team."
        )

        evaluateAchievements()
        saveGame()

    }

    private func processMonthlyFinances() {

        addCash(company.monthlyProfit)

        company.lifetimeRevenue +=
            max(0, company.monthlyRevenue)

        let unlockedSegmentRevenue = company.marketSegments.reduce(0) {
            $0 + ($1.unlocked ? $1.monthlyRevenueBonus : 0)
        }

        if unlockedSegmentRevenue > 0 {
            addCash(unlockedSegmentRevenue)
            company.lifetimeRevenue += unlockedSegmentRevenue
        }

        if company.monthlyProfit > 0 {
            company.companyPerkPoints +=
                company.unlockedCompanyPerks.contains(.founderDiscipline)
                ? 2
                : 1
        }

    }

    private func processCustomerChurn() -> Int {

        let totalCustomers = company.products.reduce(0) {

            $0 + $1.customers

        }

        guard totalCustomers > 0 else {

            company.customerSatisfaction =
                min(100, company.customerSatisfaction + 1)

            return 0

        }

        let qualityPressure = max(0, 1 - company.productQuality)

        let strategySatisfaction =
            company.products.reduce(0) {
                $0 + $1.strategy.satisfactionEffect
            }

        let worldChurn =
            company.activeWorldEvent?.churnMultiplier ?? 1

        let supportRelief =
            max(0, company.supportCapacity - 1) * 0.025

        let churnRate =
            max(
                0.002,
                min(0.20, company.churnRisk + qualityPressure * 0.08) -
                supportRelief
            ) *
            worldChurn

        let churnedCustomers =
            max(0, Int(Double(totalCustomers) * churnRate))

        guard churnedCustomers > 0 else {

            improveCustomerSatisfaction(
                by: company.supportCapacity >= 1 ? 2 : 1
            )

            return 0

        }

        var remainingChurn = churnedCustomers

        for index in company.products.indices {

            guard remainingChurn > 0 else { break }

            let productCustomers = company.products[index].customers

            let share =
                Double(productCustomers) / Double(totalCustomers)

            let lost =
                min(
                    productCustomers,
                    max(1, Int(Double(churnedCustomers) * share))
                )

            company.products[index].customers -= lost

            remainingChurn -= lost

        }

        let rawSatisfactionLoss =
            Int(
                Double(churnedCustomers) /
                Double(max(totalCustomers, 1)) *
                100
            )

        let supportRecovery =
            company.supportCapacity >= 1.1 ? 2 :
            company.supportCapacity >= 0.85 ? 1 : 0

        let satisfactionLoss =
            max(0, rawSatisfactionLoss - supportRecovery)

        company.customerSatisfaction =
            max(0, company.customerSatisfaction - satisfactionLoss)

        if satisfactionLoss == 0 {

            improveCustomerSatisfaction(by: max(1, strategySatisfaction))

        }

        if company.customerSatisfaction < 45 {

            company.reputation =
                max(0, company.reputation - 2)

        }

        return churnedCustomers

    }

    private func updateWorldEvent() {

        if company.activeWorldEventMonthsRemaining > 0 {

            company.activeWorldEventMonthsRemaining -= 1

            if company.activeWorldEventMonthsRemaining == 0 {

                addNotification(
                    title: "Industry Shift Ended",
                    message: company.activeWorldEvent?.title ?? "Market conditions normalized."
                )

                company.activeWorldEvent = nil

            }

            return

        }

        guard Int.random(in: 1...100) <= 18 else {
            return
        }

        let event = availableWorldEvents.randomElement()

        company.activeWorldEvent = event

        company.activeWorldEventMonthsRemaining =
            event?.durationMonths ?? 0

        if let event {

            company.reputation =
                min(100, max(0, company.reputation + event.reputationEffect))

            addNotification(
                title: event.title,
                message: event.summary
            )

            company.latestNews = event.summary

        }

    }

    private var availableWorldEvents: [Company.WorldEvent] {

        [
            Company.WorldEvent(
                title: "GPU Supply Crunch",
                summary: "Cloud capacity tightened across the AI industry.",
                demandMultiplier: 0.90,
                churnMultiplier: 1.15,
                researchMultiplier: 0.85,
                reputationEffect: 0,
                durationMonths: 3
            ),
            Company.WorldEvent(
                title: "Enterprise AI Boom",
                summary: "Large companies accelerated AI adoption.",
                demandMultiplier: 1.25,
                churnMultiplier: 0.95,
                researchMultiplier: 1.00,
                reputationEffect: 1,
                durationMonths: 4
            ),
            Company.WorldEvent(
                title: "AI Regulation Wave",
                summary: "New compliance pressure slowed risky launches.",
                demandMultiplier: 0.85,
                churnMultiplier: 0.90,
                researchMultiplier: 0.95,
                reputationEffect: -1,
                durationMonths: 3
            ),
            Company.WorldEvent(
                title: "Open Source Breakthrough",
                summary: "Open models raised customer expectations overnight.",
                demandMultiplier: 0.95,
                churnMultiplier: 1.25,
                researchMultiplier: 1.20,
                reputationEffect: 0,
                durationMonths: 3
            ),
            Company.WorldEvent(
                title: "AI Talent War",
                summary: "Top researchers became harder to recruit as labs bid up compensation.",
                demandMultiplier: 1.00,
                churnMultiplier: 1.00,
                researchMultiplier: 0.90,
                reputationEffect: 0,
                durationMonths: 2
            ),
            Company.WorldEvent(
                title: "Enterprise Security Panic",
                summary: "Buyers started demanding stronger controls before renewing AI contracts.",
                demandMultiplier: 0.88,
                churnMultiplier: 1.20,
                researchMultiplier: 1.00,
                reputationEffect: -1,
                durationMonths: 3
            ),
            Company.WorldEvent(
                title: "Developer Tooling Wave",
                summary: "New developer workflows increased demand for practical AI products.",
                demandMultiplier: 1.18,
                churnMultiplier: 0.92,
                researchMultiplier: 1.05,
                reputationEffect: 1,
                durationMonths: 4
            ),
            Company.WorldEvent(
                title: "Cloud Price Drop",
                summary: "Infrastructure providers cut GPU prices and made experimentation cheaper.",
                demandMultiplier: 1.05,
                churnMultiplier: 0.96,
                researchMultiplier: 1.25,
                reputationEffect: 0,
                durationMonths: 2
            )
        ]

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

            churnedCustomers: lastChurnedCustomers,

            endingCustomerSatisfaction: company.customerSatisfaction,

            marketShare: company.marketShare,

            worldEventTitle: company.activeWorldEvent?.title,

            endingCash: company.cash

        )

        addNotification(
            title: "📊 Monthly Report",
            message: "Month closed with \(company.monthlyProfit >= 0 ? "a profit" : "a loss")."
        )

    }

    private func processMonthlyPulse() {

        guard Int.random(in: 1...100) <= 55 else {
            return
        }

        let productStaff =
            company.employees.filter { $0.department == .product }.count

        let researchStaff =
            company.employees.filter { $0.department == .research }.count

        if company.customerSatisfaction >= 90 {

            let advocates = Int.random(in: 200...700)

            if let first = company.products.indices.first {
                company.products[first].customers += advocates
            }

            company.reputation = min(100, company.reputation + 1)

            addNotification(
                title: "Customer Advocates",
                message: "Happy customers brought in \(advocates) organic signups."
            )

            return

        }

        if company.customerSatisfaction < 50 {

            company.reputation = max(0, company.reputation - 1)

            addNotification(
                title: "Customer Backlash",
                message: "Low satisfaction is spilling into public perception."
            )

            return

        }

        if company.runwayMonths < 3 {

            company.companyValue =
                max(0, company.companyValue - 10_000)

            addNotification(
                title: "Investor Pressure",
                message: "Short runway made the market more skeptical of your next round."
            )

            return

        }

        if productStaff >= 2 &&
           company.supportCapacity >= 1 {

            improveCustomerSatisfaction(by: 2)

            addNotification(
                title: "Product Team Win",
                message: "Product and support work improved customer sentiment this month."
            )

            return

        }

        if researchStaff >= 2 &&
           company.activeResearch != nil {

            addResearchPoints(Double.random(in: 25...60))

            addNotification(
                title: "Lab Breakthrough",
                message: "Research staff found a shortcut in the active project."
            )

            return

        }

        if company.monthlyProfit > 0 {

            company.reputation = min(100, company.reputation + 1)

            addNotification(
                title: "Founder Letter",
                message: "A transparent monthly update strengthened confidence in the company."
            )

        }

    }

    private func processEmployeeMoraleAndPoaching() {

        guard !company.employees.isEmpty else { return }

        let profitable = company.monthlyProfit >= 0
        let hasHiringBrand =
            company.unlockedCompanyPerks.contains(.hiringBrand)

        for index in company.employees.indices {

            let burnoutIncrease =
                company.activeResearch == nil ? 1 : 3

            company.employees[index].burnout =
                min(100, company.employees[index].burnout + burnoutIncrease)

            if profitable {
                company.employees[index].morale =
                    min(100, company.employees[index].morale + 2)
                company.employees[index].loyalty =
                    min(100, company.employees[index].loyalty + 1)
            } else {
                company.employees[index].morale =
                    max(0, company.employees[index].morale - 3)
                company.employees[index].loyalty =
                    max(0, company.employees[index].loyalty - 2)
            }

            if hasHiringBrand {
                company.employees[index].loyalty =
                    min(100, company.employees[index].loyalty + 2)
            }

            if company.employees[index].burnout > 70 {
                company.employees[index].morale =
                    max(0, company.employees[index].morale - 3)
            }

        }

        guard company.employees.count > 1 else { return }

        let poachableIndexes = company.employees.indices.filter {
            company.employees[$0].name != "You" &&
            company.employees[$0].loyalty < 42 &&
            company.employees[$0].skill >= 65
        }

        guard let index = poachableIndexes.randomElement() else { return }

        let poachChance = hasHiringBrand ? 12 : 28

        guard Int.random(in: 1...100) <= poachChance else { return }

        let employee = company.employees.remove(at: index)

        if let rivalIndex = company.competitors.indices.randomElement() {
            company.competitors[rivalIndex].employees += 1
            company.competitors[rivalIndex].rivalryHeat =
                min(100, company.competitors[rivalIndex].rivalryHeat + 12)
            company.competitors[rivalIndex].signatureMove =
                "Poached \(employee.name)"

            addNotification(
                title: "Talent Poached",
                message: "\(company.competitors[rivalIndex].name) poached \(employee.name). Loyalty matters now."
            )
        }

    }

    private func processInvestorRelationships() {

        guard !company.activeInvestors.isEmpty else { return }

        let delta: Int

        if company.monthlyProfit > 0 &&
           company.customerSatisfaction >= 70 {
            delta = 3
        } else if company.runwayMonths < 4 ||
                  company.customerSatisfaction < 55 {
            delta = -5
        } else {
            delta = 1
        }

        for index in company.activeInvestors.indices {
            company.activeInvestors[index].relationship =
                min(100, max(0, company.activeInvestors[index].relationship + delta))
        }

        for index in company.investors.indices where company.investors[index].invested {
            company.investors[index].relationship =
                min(100, max(0, company.investors[index].relationship + delta))
        }

        if delta < 0 {
            addNotification(
                title: "Board Pressure",
                message: "Investor confidence slipped due to weak fundamentals."
            )
        }

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

        company.customerSatisfaction =
            min(
                100,
                max(0, company.customerSatisfaction + option.satisfactionEffect)
            )

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

        saveGame()

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

        saveGame()

    }

    func launchCustomerSuccessSprint() {

        let cost = company.customerSuccessCost

        guard spendCash(cost) else {

            addNotification(
                title: "Customer Success Delayed",
                message: "You need $\(Int(cost).formatted()) to fund a customer success sprint."
            )

            return

        }

        var satisfactionGain =
            company.supportCapacity >= 1 ? 10 : 6

        if company.unlockedCompanyPerks.contains(.customerSuccessOps) {
            satisfactionGain += 4
        }

        improveCustomerSatisfaction(by: satisfactionGain)

        company.churnRisk =
            max(0.005, company.churnRisk - 0.01)

        company.reputation =
            min(100, company.reputation + 1)

        addNotification(
            title: "Customer Success Sprint",
            message:
                "Support improvements raised satisfaction by \(satisfactionGain)% and lowered churn risk."
        )

        saveGame()

    }

    private func improveCustomerSatisfaction(by amount: Int) {

        company.customerSatisfaction =
            min(100, company.customerSatisfaction + amount)

    }

    func unlockCompanyPerk(_ perk: Company.CompanyPerk) {

        guard !company.unlockedCompanyPerks.contains(perk) else { return }

        guard company.companyPerkPoints >= perk.cost else {

            addNotification(
                title: "Perk Locked",
                message: "\(perk.rawValue) requires \(perk.cost) company perk points."
            )

            return

        }

        company.companyPerkPoints -= perk.cost
        company.unlockedCompanyPerks.insert(perk)

        if perk == .boardWhisperer {
            improveInvestorRelationships(by: 8)
        }

        addNotification(
            title: "Company Perk Unlocked",
            message: "\(perk.rawValue): \(perk.summary)"
        )

        saveGame()

    }

    func expandMarketSegment(id: UUID) {

        guard let index = company.marketSegments.firstIndex(where: {
            $0.id == id
        }) else {
            return
        }

        guard !company.marketSegments[index].unlocked else { return }

        guard company.reputation >= company.marketSegments[index].reputationRequired else {

            addNotification(
                title: "Expansion Blocked",
                message: "\(company.marketSegments[index].name) requires \(company.marketSegments[index].reputationRequired) reputation."
            )

            return

        }

        guard spendCash(company.marketSegments[index].unlockCost) else {

            addNotification(
                title: "Expansion Blocked",
                message: "You need $\(Int(company.marketSegments[index].unlockCost).formatted()) to enter \(company.marketSegments[index].name)."
            )

            return

        }

        company.marketSegments[index].unlocked = true
        company.marketSegments[index].localShare = 5
        company.monthlyRevenue +=
            company.marketSegments[index].monthlyRevenueBonus
        changeMarketShare(by: 1)

        addNotification(
            title: "Market Segment Unlocked",
            message: "\(company.marketSegments[index].name) is now contributing new revenue."
        )

        evaluateAchievements()
        saveGame()

    }

    func fundFrontierProject(id: UUID) {

        guard let index = company.frontierProjects.firstIndex(where: {
            $0.id == id
        }) else {
            return
        }

        guard !company.frontierProjects[index].completed else { return }

        if let technology = company.frontierProjects[index].requiredTechnology,
           !company.hasUnlockedTechnology(technology) {

            addNotification(
                title: "Frontier Project Locked",
                message: "\(company.frontierProjects[index].name) requires \(technology)."
            )

            return

        }

        let cloudDiscount =
            company.unlockedCompanyPerks.contains(.cloudNegotiator) ? 0.85 : 1

        let projectSpeed =
            company.unlockedCompanyPerks.contains(.frontierOperator) ? 1.25 : 1

        let baseCost =
            max(25_000, company.frontierProjects[index].totalCost * 0.18)

        let cost = baseCost * cloudDiscount

        guard spendCash(cost) else {

            addNotification(
                title: "Frontier Funding Blocked",
                message: "You need $\(Int(cost).formatted()) for the next \(company.frontierProjects[index].name) milestone."
            )

            return

        }

        let progressGain =
            (cost / company.frontierProjects[index].totalCost) *
            100 *
            projectSpeed

        company.frontierProjects[index].progress =
            min(100, company.frontierProjects[index].progress + progressGain)

        if company.frontierProjects[index].progress >= 100 {
            completeFrontierProject(at: index)
        } else {
            addNotification(
                title: "Frontier Project Advanced",
                message: "\(company.frontierProjects[index].name) reached \(Int(company.frontierProjects[index].progress))%."
            )
        }

        saveGame()

    }

    private func completeFrontierProject(at index: Int) {

        company.frontierProjects[index].completed = true
        company.companyValue += company.frontierProjects[index].valuationReward
        company.reputation =
            min(
                100,
                company.reputation + company.frontierProjects[index].reputationReward
            )
        company.researchPoints += company.frontierProjects[index].researchReward

        addNotification(
            title: "Frontier Project Complete",
            message: "\(company.frontierProjects[index].name) became a company-defining capability."
        )

        evaluateAchievements()

    }

    private func improveInvestorRelationships(by amount: Int) {

        for index in company.activeInvestors.indices {
            company.activeInvestors[index].relationship =
                min(100, company.activeInvestors[index].relationship + amount)
        }

        for index in company.investors.indices where company.investors[index].invested {
            company.investors[index].relationship =
                min(100, company.investors[index].relationship + amount)
        }

    }

    private func evaluateAchievements() {

        let achievements: [(Company.GameAchievement, Bool)] = [
            (.firstHire, company.employees.count > 1),
            (.firstContract, company.completedContracts > 0),
            (.customerHero, company.customerSatisfaction >= 90),
            (
                .founderControl,
                company.companyValue >= 10_000_000 &&
                company.founderOwnership >= 80
            ),
            (.unicornBuilder, company.companyValue >= 1_000_000_000),
            (.frontierLab, company.frontierProjects.contains { $0.completed }),
            (
                .globalExpansion,
                company.marketSegments.filter { $0.unlocked }.count >= 3
            ),
            (
                .loyalTeam,
                company.employees.count >= 5 &&
                averageEmployeeLoyalty >= 85
            )
        ]

        for (achievement, unlocked) in achievements where unlocked {

            guard !company.unlockedAchievements.contains(achievement) else {
                continue
            }

            company.unlockedAchievements.insert(achievement)

            addNotification(
                title: "Achievement Unlocked",
                message: "\(achievement.rawValue) (\(achievement.gameCenterID))"
            )

        }

    }

    private var averageEmployeeLoyalty: Int {

        guard !company.employees.isEmpty else { return 0 }

        let total = company.employees.reduce(0) {
            $0 + $1.loyalty
        }

        return total / company.employees.count

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

        if company.activeInvestors.isEmpty &&
           company.founderOwnership >= 90 &&
           company.monthlyProfit >= 50_000 &&
           company.cash >= 500_000 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "You built a profitable AI company without giving up control. A rare founder-led win."
            )

            addNotification(
                title: "Bootstrapped Victory",
                message: "Your startup became highly profitable while staying founder-controlled."
            )

            return

        }

        if company.releasedAIModelCount >= 4 &&
           company.unlockedTechnologyCount >= 5 &&
           company.companyValue >= 50_000_000 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "You turned the company into a frontier research lab with a portfolio of breakthrough AI models."
            )

            addNotification(
                title: "Research Victory",
                message: "Your lab now defines the technical frontier."
            )

            return

        }

        if company.companyValue >= 500_000_000 &&
           company.monthlyProfit >= 100_000 &&
           company.founderOwnership >= 35 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "IPO Victory: you took a profitable AI company public while keeping meaningful founder control."
            )

            addNotification(
                title: "IPO Victory",
                message: "Your company is public, profitable, and still founder-led."
            )

            return

        }

        if company.companyValue >= 250_000_000 &&
           company.cash >= 5_000_000 &&
           company.customerSatisfaction >= 88 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "Strategic Acquisition Victory: a platform giant acquired your beloved AI company for a premium exit."
            )

            addNotification(
                title: "Acquisition Victory",
                message: "Your customer love and cash position created a premium exit."
            )

            return

        }

        if company.companyValue >= 1_000_000_000 &&
           company.activeInvestors.count >= 2 &&
           company.monthlyRevenue >= 250_000 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "You built a venture-backed AI unicorn with enough revenue to justify the hype."
            )

            addNotification(
                title: "Unicorn Victory",
                message: "Your company reached a $1B valuation."
            )

            return

        }

        if company.unlockedProductCount >= company.products.count &&
           company.totalCustomers >= 100_000 &&
           company.customerSatisfaction >= 90 {

            gameSpeed = .paused

            gameOutcome = .victory(
                "You built a beloved AI product ecosystem with massive adoption and unusually happy customers."
            )

            addNotification(
                title: "Product Ecosystem Victory",
                message: "Customers love your complete AI product suite."
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

        saveGame()

    }
    
    

}
