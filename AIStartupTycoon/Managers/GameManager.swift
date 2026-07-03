import Foundation
import Observation

@Observable
class GameManager {

    var company = Company()
    
    var secondsElapsed = 0

    // MARK: Passive Income

    func tick() {

        company.cash += company.monthlyRevenue / 30

    }

    // MARK: Build Product

    func buildProduct(index: Int) {

        guard company.products.indices.contains(index) else {
            return
        }

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

    // MARK: Hire Engineer

    func hireEngineer() {

        let cost = 500.0

        guard company.cash >= cost else {

            company.latestNews = "❌ Not enough cash."

            return

        }

        company.cash -= cost

        let newEmployee = Employee(

            name: "Engineer \(company.employees.count)",

            role: .juniorEngineer,

            salary: 4000,

            skill: Int.random(in: 40...70)

        )

        company.employees.append(newEmployee)

        company.latestNews = "👨‍💻 Hired \(newEmployee.name)"

    }

    // MARK: Unlock Products

    private func unlockProducts() {

        if company.products[0].level >= 5 {

            company.products[1].unlocked = true

        }

        if company.products[1].level >= 5 {

            company.products[2].unlocked = true

        }

    }
    
    func employeeWork() {

        var revenueGain = 0.0

        for employee in company.employees {

            revenueGain += employee.productivity * 5

        }

        company.cash += revenueGain
    }
    
    func growProducts() {

        for index in company.products.indices {

            guard company.products[index].unlocked else { continue }

            let growth = company.products[index].dailyGrowth

            company.products[index].customers += growth

        }

    }
    
    func acceptInvestment(index: Int) {

        guard company.investors.indices.contains(index) else { return }

        guard !company.investors[index].invested else {

            company.latestNews = "⚠️ Already invested."

            return
        }

        company.cash += company.investors[index].investment

        company.founderOwnership -= company.investors[index].equity

        company.investors[index].invested = true

        company.investors[index].investedDate =
            "Year \(company.currentYear) • Month \(company.currentMonth)"

        company.latestNews =
            "💰 \(company.investors[index].name) invested $\(Int(company.investors[index].investment).formatted())"
    }
    
    func nextMonth() {

        company.cash += company.monthlyProfit

        company.currentMonth += 1

        if company.currentMonth > 12 {

            company.currentMonth = 1
            company.currentYear += 1

        }

        company.latestNews =
            "📅 Advanced to Year \(company.currentYear), Month \(company.currentMonth)"

    }

}
//  GameManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

