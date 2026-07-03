import Foundation

struct GameEvent: Identifiable {

    let id = UUID()

    let title: String
    let description: String

    let cashReward: Double
    let companyValueReward: Double
    let customerReward: Int

}
//  GameEvent.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

