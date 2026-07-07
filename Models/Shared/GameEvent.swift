import Foundation

struct GameEvent: Identifiable {

    let id = UUID()

    let title: String
    let description: String

    let options: [GameEventOption]

}

struct GameEventOption: Identifiable {

    let id = UUID()

    let title: String
    let description: String

    let cashEffect: Double
    let companyValueEffect: Double
    let customerEffect: Int
    let researchEffect: Double
    let reputationEffect: Int
    let marketShareEffect: Double

}
//  GameEvent.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//
