import Foundation

struct EventManager {

    static let events: [GameEvent] = [

        GameEvent(
            title: "🚀 Product Goes Viral",
            description: "Thousands of new users discovered your startup.",
            cashReward: 10000,
            companyValueReward: 50000,
            customerReward: 1000
        ),

        GameEvent(
            title: "📰 Featured on TechCrunch",
            description: "Your company received major press coverage.",
            cashReward: 25000,
            companyValueReward: 100000,
            customerReward: 2500
        ),

        GameEvent(
            title: "⚠️ Server Outage",
            description: "Unexpected downtime hurt your reputation.",
            cashReward: -5000,
            companyValueReward: -15000,
            customerReward: -300
        )

    ]

}
//  EventManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

