import Foundation

struct Product: Identifiable {

    let id = UUID()

    let name: String
    let description: String

    var level: Int = 0

    let buildCost: Double
    let revenuePerLevel: Double

    var customers: Int = 0

    var unlocked: Bool = true

}
//  Products.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

