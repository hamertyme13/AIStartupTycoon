import Foundation

struct Technology: Identifiable {

    let id = UUID()

    let name: String
    let description: String

    var progress: Double = 0

    let requiredResearch: Double

    var unlocked = false

    var completed = false

}
//  Technology.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

