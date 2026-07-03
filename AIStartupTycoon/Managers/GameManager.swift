import Foundation
import Observation

@Observable
class GameManager {

    // MARK: - Game State

    var company = Company()

    var secondsElapsed = 0

    var currentEvent: GameEvent?

    var latestReport: MonthlyReport?

    // MARK: - Notifications

    func addNotification(title: String, message: String) {

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

        company.cash += company.monthlyRevenue / 30

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

        guard company.cash >= cost else {

            addNotification(
                title: "❌ Not Enough Cash",
                message: "You need more money to build this product."
            )

            return

        }

        company.cash -= cost

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

        if company.products.indices.contains(1),
           company.products[0].level >= 5 {

            company.products[1].unlocked = true

            addNotification(
                title: "🔓 Product Unlocked",
                message: "\(company.products[1].name) is now available."
            )

        }

        if company.products.indices.contains(2),
           company.products[1].level >= 5 {

            company.products[2].unlocked = true

            addNotification(
                title: "🔓 Product Unlocked",
                message: "\(company.products[2].name) is now available."
            )

        }

        if company.products.indices.contains(3),
           company.products[2].level >= 5 {

            company.products[3].unlocked = true

            addNotification(
                title: "🔓 Product Unlocked",
                message: "\(company.products[3].name) is now available."
            )

        }

    }

    func growProducts() {

        for index in company.products.indices {

            guard company.products[index].unlocked else { continue }

            company.products[index].customers +=
                company.products[index].dailyGrowth

        }

    }

    // MARK: - Employees

    func hireEngineer() {

        let cost = 500.0

        guard company.cash >= cost else {

            addNotification(
                title: "❌ Not Enough Cash",
                message: "You can't afford another engineer."
            )

            return

        }

        company.cash -= cost

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

        let revenueGain = company.employees.reduce(0) {

            $0 + ($1.productivity * 5)

        }

        company.cash += revenueGain

    }

    // MARK: - Research

    func addResearchPoints(_ amount: Double) {

        company.researchPoints += amount

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

        company.cash += company.investors[index].investment

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

        company.cash += company.monthlyProfit

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

        company.cash += event.cashReward

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

    // MARK: - Market

    private func changeMarketShare(by amount: Double) {

        company.marketShare += amount

        company.marketShare =
            min(max(company.marketShare, 1), 95)

    }

}
