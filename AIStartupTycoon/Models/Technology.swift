import Foundation

struct Technology: Identifiable {

    let id = UUID()

    let name: String

    let description: String

    let requiredResearch: Double

    var progress: Double = 0

    var unlocked = false

}
//  Technology.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

