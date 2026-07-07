import Foundation

struct EventManager {

    static let events: [GameEvent] = [

        GameEvent(
            title: "🚀 Product Goes Viral",
            description: "Thousands of new users discovered your startup.",
            options: [
                GameEventOption(
                    title: "Scale Immediately",
                    description: "Spend cash on infrastructure to keep the momentum.",
                    cashEffect: -8_000,
                    companyValueEffect: 80_000,
                    customerEffect: 2_000,
                    researchEffect: 0,
                    reputationEffect: 4,
                    marketShareEffect: 1.5
                ),
                GameEventOption(
                    title: "Monetize the Spike",
                    description: "Convert attention into short-term revenue.",
                    cashEffect: 20_000,
                    companyValueEffect: 35_000,
                    customerEffect: 800,
                    researchEffect: 0,
                    reputationEffect: 1,
                    marketShareEffect: 0.5
                )
            ]
        ),

        GameEvent(
            title: "📰 Featured on TechCrunch",
            description: "Your company received major press coverage.",
            options: [
                GameEventOption(
                    title: "Court Investors",
                    description: "Use the press cycle to lift valuation.",
                    cashEffect: 0,
                    companyValueEffect: 150_000,
                    customerEffect: 600,
                    researchEffect: 0,
                    reputationEffect: 3,
                    marketShareEffect: 0.5
                ),
                GameEventOption(
                    title: "Recruit Aggressively",
                    description: "Turn the spotlight into a stronger hiring brand.",
                    cashEffect: -5_000,
                    companyValueEffect: 60_000,
                    customerEffect: 300,
                    researchEffect: 60,
                    reputationEffect: 5,
                    marketShareEffect: 0.2
                )
            ]
        ),

        GameEvent(
            title: "⚠️ Server Outage",
            description: "Unexpected downtime hurt your reputation.",
            options: [
                GameEventOption(
                    title: "Issue Refunds",
                    description: "Protect trust at the cost of cash.",
                    cashEffect: -12_000,
                    companyValueEffect: -5_000,
                    customerEffect: -100,
                    researchEffect: 0,
                    reputationEffect: 2,
                    marketShareEffect: -0.2
                ),
                GameEventOption(
                    title: "Patch Quietly",
                    description: "Spend less, but accept damage to trust.",
                    cashEffect: -3_000,
                    companyValueEffect: -25_000,
                    customerEffect: -600,
                    researchEffect: 0,
                    reputationEffect: -4,
                    marketShareEffect: -1.0
                )
            ]
        ),

        GameEvent(
            title: "🏢 Enterprise Pilot Offer",
            description: "A large customer wants a custom AI deployment.",
            options: [
                GameEventOption(
                    title: "Accept the Pilot",
                    description: "Gain cash and credibility, but distract research.",
                    cashEffect: 35_000,
                    companyValueEffect: 75_000,
                    customerEffect: 200,
                    researchEffect: -50,
                    reputationEffect: 2,
                    marketShareEffect: 0.4
                ),
                GameEventOption(
                    title: "Stay Focused",
                    description: "Keep the roadmap clean and invest in core research.",
                    cashEffect: 0,
                    companyValueEffect: 15_000,
                    customerEffect: 0,
                    researchEffect: 120,
                    reputationEffect: 1,
                    marketShareEffect: 0
                )
            ]
        ),

        GameEvent(
            title: "⚖️ AI Safety Backlash",
            description: "Public concern grows around your latest model behavior.",
            options: [
                GameEventOption(
                    title: "Pause and Audit",
                    description: "Lose momentum while rebuilding trust.",
                    cashEffect: -10_000,
                    companyValueEffect: -20_000,
                    customerEffect: -200,
                    researchEffect: 40,
                    reputationEffect: 5,
                    marketShareEffect: -0.5
                ),
                GameEventOption(
                    title: "Defend the Launch",
                    description: "Keep growth moving, but risk reputation.",
                    cashEffect: 5_000,
                    companyValueEffect: 20_000,
                    customerEffect: 500,
                    researchEffect: 0,
                    reputationEffect: -5,
                    marketShareEffect: 0.6
                )
            ]
        )

    ]

}
//  EventManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//
