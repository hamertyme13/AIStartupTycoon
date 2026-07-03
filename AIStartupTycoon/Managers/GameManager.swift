import Foundation
import Observation

@Observable
class GameManager {

    // MARK: - Game State

    var company = Company()

    var secondsElapsed = 0

    var currentEvent: GameEvent?

    var latestReport: MonthlyReport?

    // MARK: - Game Loop

    func tick() {

        company.cash += company.monthlyRevenue / 30

    }

    // MARK: - Products

    func buildProduct(index: Int) {

        guard company.products.indices.contains(index) else { return }

        guard company.products[index].unlocked else {

            company.latestNews = "🔒 Product locked."

            return

        }

        let cost = company.products[index].buildCost

        guard company.cash >= cost else {

            company.latestNews = "❌ Not enough cash."

            return

        }

        company.cash -= cost

        company.products[index].level += 1

        company.products[index].customers += 100

        company.monthlyRevenue += company.products[index].revenuePerLevel

        company.companyValue += company.products[index].revenuePerLevel * 5

        company.latestNews =
        "🚀 \(company.products[index].name) upgraded to Level \(company.products[index].level)"

        unlockProducts()

    }

    private func unlockProducts() {

        if company.products.indices.contains(1),
           company.products[0].level >= 5 {

            company.products[1].unlocked = true

        }

        if company.products.indices.contains(2),
           company.products[1].level >= 5 {

            company.products[2].unlocked = true

        }

        if company.products.indices.contains(3),
           company.products[2].level >= 5 {

            company.products[3].unlocked = true

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

            company.latestNews = "❌ Not enough cash."

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

        company.latestNews = "👨‍💻 Hired \(employee.name)"

    }

    func employeeWork() {

        var revenueGain = 0.0

        for employee in company.employees {

            revenueGain += employee.productivity * 5

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

            company.latestNews = "⚠️ Already invested."

            return

        }

        company.cash += company.investors[index].investment

        company.founderOwnership -=
            company.investors[index].equity

        company.investors[index].invested = true

        company.investors[index].investedDate =
        "Year \(company.currentYear) • Month \(company.currentMonth)"

        company.latestNews =
        "💰 \(company.investors[index].name) invested $\(Int(company.investors[index].investment).formatted())"

    }

    // MARK: - Monthly Simulation

    func nextMonth() {

        processMonthlyFinances()

        createMonthlyReport()

        advanceCalendar()

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

    }

    private func advanceCalendar() {

        company.currentMonth += 1

        if company.currentMonth > 12 {

            company.currentMonth = 1

            company.currentYear += 1

        }

        company.latestNews =
        "📅 Advanced to Year \(company.currentYear) • Month \(company.currentMonth)"

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

        if let firstProduct = company.products.indices.first {

            company.products[firstProduct].customers +=
                event.customerReward

        }

        company.latestNews = event.title

        currentEvent = nil

    }

}
