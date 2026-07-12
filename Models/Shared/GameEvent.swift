import Foundation

struct GameEvent: Identifiable, Codable {

    var id = UUID()

    let title: String
    let description: String

    let options: [GameEventOption]

}

struct GameEventOption: Identifiable, Codable {

    var id = UUID()

    let title: String
    let description: String

    let cashEffect: Double
    let companyValueEffect: Double
    let customerEffect: Int
    let researchEffect: Double
    let reputationEffect: Int
    let marketShareEffect: Double
    let satisfactionEffect: Int

    init(
        title: String,
        description: String,
        cashEffect: Double,
        companyValueEffect: Double,
        customerEffect: Int,
        researchEffect: Double,
        reputationEffect: Int,
        marketShareEffect: Double,
        satisfactionEffect: Int = 0
    ) {

        self.title = title
        self.description = description
        self.cashEffect = cashEffect
        self.companyValueEffect = companyValueEffect
        self.customerEffect = customerEffect
        self.researchEffect = researchEffect
        self.reputationEffect = reputationEffect
        self.marketShareEffect = marketShareEffect
        self.satisfactionEffect = satisfactionEffect

    }

}
//  GameEvent.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//
