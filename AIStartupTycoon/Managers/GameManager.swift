import Foundation
import Observation

@Observable
class GameManager {

    var company = Company()

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

            company.latestNews = "❌ Not enough cash to hire."

            return
        }

        company.cash -= cost

        company.employeeCount += 1

        company.latestNews = "👨‍💻 Engineer hired."

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

}
//  GameManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

