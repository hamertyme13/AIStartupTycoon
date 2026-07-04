import Foundation

struct CEO: Identifiable {

    let id = UUID()

    let name: String

    let title: String

    let personality: Personality

    enum Personality: String {

        case visionary
        case dealmaker
        case engineer
        case scientist
        case marketer

    }

}
//  CEO.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

