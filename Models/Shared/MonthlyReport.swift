import Foundation

struct MonthlyReport: Identifiable, Codable {

    var id = UUID()

    let month: Int
    let year: Int

    let revenue: Double
    let payroll: Double
    let officeRent: Double
    let serverCost: Double
    let researchCost: Double
    let churnedCustomers: Int
    let endingCustomerSatisfaction: Int
    let marketShare: Double
    let worldEventTitle: String?

    var totalExpenses: Double {
        payroll + officeRent + serverCost + researchCost
    }

    var profit: Double {
        revenue - totalExpenses
    }

    let endingCash: Double

}
//  MonthlyReport.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/2/26.
//
