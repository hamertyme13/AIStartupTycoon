import Foundation

struct Competitor: Identifiable, Codable {

    var id = UUID()

    var name: String

    var cash: Double

    var revenue: Double

    var valuation: Double

    var employees: Int

    var products: Int

    var marketShare: Double
    
    var currentModel = "None"

    var aiModelsReleased = 0

    var researchProgress: Double = 0

    var nextModelProgress: Double = 100

    var aiRating: Double = 50
    
    var ceo: CEO

    var rivalryHeat: Int = 30

    var signatureMove = "Watching the market"
    
    init(
        name: String,
        ceo: CEO,
        cash: Double,
        revenue: Double,
        valuation: Double,
        employees: Int,
        products: Int,
        marketShare: Double
    ) {
        self.name = name
        self.ceo = ceo
        self.cash = cash
        self.revenue = revenue
        self.valuation = valuation
        self.employees = employees
        self.products = products
        self.marketShare = marketShare
    }

}
//  Competitor.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//
