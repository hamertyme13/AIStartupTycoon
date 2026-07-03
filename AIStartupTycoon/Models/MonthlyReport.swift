import Foundation

struct MonthlyReport: Identifiable {

    let id = UUID()

    let month: Int
    let year: Int

    let revenue: Double
    let payroll: Double
    let officeRent: Double
    let serverCost: Double
    let researchCost: Double

    var totalExpenses: Double {
        payroll + officeRent + serverCost + researchCost
    }

    var profit: Double {
        revenue - totalExpenses
    }

    let endingCash: Double

}
//  MonthlyReport.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

