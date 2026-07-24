import Foundation

struct Office: Identifiable, Codable {

    var id = UUID()

    let name: String

    let cost: Double

    let monthlyRent: Double

    let productivityBonus: Double

    let researchBonus: Double

    let reputationBonus: Int

    let icon: String

}
//  Office.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
