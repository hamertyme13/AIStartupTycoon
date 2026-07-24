import Foundation

enum GameSpeed: String, CaseIterable, Codable {

    case paused = "Pause"
    case slow = "Slow"
    case normal = "Normal"
    case fast = "Fast"

    var secondsPerMonth: Int {

        switch self {

        case .paused:
            return .max

        case .slow:
            return 180

        case .normal:
            return 120

        case .fast:
            return 60

        }

    }

    var icon: String {

        switch self {

        case .paused:
            return "pause.fill"

        case .slow:
            return "tortoise.fill"

        case .normal:
            return "play.fill"

        case .fast:
            return "hare.fill"

        }

    }

}
//  GameSpeed.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
