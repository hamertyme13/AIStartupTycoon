import Foundation
import Observation

@Observable
class GameManager {

    // MARK: - Game State

    var company = Company()

    var secondsElapsed = 0

    var currentEvent: GameEvent?

    var latestReport: MonthlyReport?

    // MARK: - Time
    
    var gameSpeed: GameSpeed = .normal
    
    var secondsPerMonth: Int {
        
        gameSpeed.secondsPerMonth
        
    }
    
    // MARK: - Notifications

    private func addNotification(title: String, message: String) {

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

        employeeWork()

        employeeResearch()

        updateEmployees()

        growProducts()

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

        for index in company.products.indices {

            guard company.products[index].unlocked else { continue }

            let growth = Double(company.products[index].dailyGrowth)

            let bonus = growth * (Double(company.reputation) / 100)

            company.products[index].customers +=
                Int(growth + bonus)

        }

    }

    // MARK: - Employees

    func hireEngineer() {

        let cost = 500.0

        guard spendCash(cost) else {
            
            addNotification(
                title: "❌ Not Enough Cash",
                message: "You can't afford another engineer."
            )
            
            return
        }

        let employee = Employee(
            name: "Engineer \(company.employees.count)",
            role: .juniorEngineer,
            salary: 4000,
            skill: Int.random(in: 40...70)
        )

        company.employees.append(employee)

        addNotification(
            title: "👨‍💻 New Hire",
            message: "\(employee.name) joined the company."
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

        }

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

        addNotification(
            title: "💰 Investment",
            message: "\(company.investors[index].name) invested $\(Int(company.investors[index].investment).formatted())"
        )

    }

    // MARK: - Monthly Simulation

    func nextMonth() {

        processMonthlyFinances()

        createMonthlyReport()

        advanceCalendar()

        updateCompetitors()

        rollForEvent()

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

            officeRent: company.officeRent,

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

        for index in company.competitors.indices {

            company.competitors[index].cash +=
                company.competitors[index].revenue

            company.competitors[index].valuation +=
                Double.random(in: 20_000...80_000)

            if Int.random(in: 1...100) <= 30 {

                company.competitors[index].employees += 1

            }

            if Int.random(in: 1...100) <= 15 {

                company.competitors[index].products += 1

                company.competitors[index].revenue +=
                    Double.random(in: 200...800)

                changeMarketShare(by: -0.2)

            }

            let change = Double.random(in: -1.5...1.5)

            company.competitors[index].marketShare =
                max(2, company.competitors[index].marketShare + change)

        }

        let competitorShare = company.competitors.reduce(0) {

            $0 + $1.marketShare

        }

        company.marketShare =
            max(1, min(95, 100 - competitorShare))

    }

    // MARK: - Events

    func rollForEvent() {

        guard Int.random(in: 1...100) <= 20 else {

            return

        }

        currentEvent = EventManager.events.randomElement()

    }

    func apply(_ event: GameEvent) {

        addCash(event.cashReward)

        company.companyValue += event.companyValueReward

        if let first = company.products.indices.first {

            company.products[first].customers +=
                event.customerReward

        }

        addNotification(
            title: "🎲 Random Event",
            message: event.title
        )

        currentEvent = nil

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

        while secondsElapsed < secondsPerMonth {

            advanceOneSecond()

            secondsElapsed += 1

        }

        secondsElapsed = 0

        nextMonth()

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
