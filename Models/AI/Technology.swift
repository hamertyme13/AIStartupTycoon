import Foundation

struct Technology: Identifiable, Codable {

    var id = UUID()

    let name: String

    let description: String

    let requiredResearch: Double

    var progress: Double = 0

    var unlocked = false

    var monthlyResearchCost: Double {

        max(1_500, requiredResearch * 20)

    }

}
//  Technology.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//
