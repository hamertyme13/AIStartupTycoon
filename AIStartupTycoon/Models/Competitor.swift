import Foundation

struct Competitor: Identifiable {

    let id = UUID()

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

}
//  Competitor.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

