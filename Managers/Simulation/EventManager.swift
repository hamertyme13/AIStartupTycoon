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
                    marketShareEffect: 1.5,
                    satisfactionEffect: 2
                ),
                GameEventOption(
                    title: "Monetize the Spike",
                    description: "Convert attention into short-term revenue.",
                    cashEffect: 20_000,
                    companyValueEffect: 35_000,
                    customerEffect: 800,
                    researchEffect: 0,
                    reputationEffect: 1,
                    marketShareEffect: 0.5,
                    satisfactionEffect: -2
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
                    marketShareEffect: -0.2,
                    satisfactionEffect: 5
                ),
                GameEventOption(
                    title: "Patch Quietly",
                    description: "Spend less, but accept damage to trust.",
                    cashEffect: -3_000,
                    companyValueEffect: -25_000,
                    customerEffect: -600,
                    researchEffect: 0,
                    reputationEffect: -4,
                    marketShareEffect: -1.0,
                    satisfactionEffect: -8
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
                    marketShareEffect: -0.5,
                    satisfactionEffect: 4
                ),
                GameEventOption(
                    title: "Defend the Launch",
                    description: "Keep growth moving, but risk reputation.",
                    cashEffect: 5_000,
                    companyValueEffect: 20_000,
                    customerEffect: 500,
                    researchEffect: 0,
                    reputationEffect: -5,
                    marketShareEffect: 0.6,
                    satisfactionEffect: -6
                )
            ]
        ),

        GameEvent(
            title: "💬 Customer Forum Erupts",
            description: "Power users are demanding roadmap changes in public.",
            options: [
                GameEventOption(
                    title: "Host a Live AMA",
                    description: "Spend founder time and support cash to rebuild trust.",
                    cashEffect: -6_000,
                    companyValueEffect: 10_000,
                    customerEffect: 300,
                    researchEffect: -20,
                    reputationEffect: 3,
                    marketShareEffect: 0.2,
                    satisfactionEffect: 8
                ),
                GameEventOption(
                    title: "Ship the Most Requested Fix",
                    description: "Delay growth work to improve product quality.",
                    cashEffect: -4_000,
                    companyValueEffect: 25_000,
                    customerEffect: 600,
                    researchEffect: 0,
                    reputationEffect: 1,
                    marketShareEffect: 0.4,
                    satisfactionEffect: 5
                )
            ]
        ),

        GameEvent(
            title: "🧑‍💻 Employee Hack Week",
            description: "The team wants a week to prototype risky ideas.",
            options: [
                GameEventOption(
                    title: "Fund the Hack Week",
                    description: "Morale rises and one prototype advances research.",
                    cashEffect: -7_500,
                    companyValueEffect: 35_000,
                    customerEffect: 0,
                    researchEffect: 90,
                    reputationEffect: 2,
                    marketShareEffect: 0.1,
                    satisfactionEffect: 1
                ),
                GameEventOption(
                    title: "Stay on Roadmap",
                    description: "Preserve cash and focus, but miss a culture moment.",
                    cashEffect: 0,
                    companyValueEffect: 5_000,
                    customerEffect: 0,
                    researchEffect: 20,
                    reputationEffect: -1,
                    marketShareEffect: 0,
                    satisfactionEffect: 0
                )
            ]
        ),

        GameEvent(
            title: "🕵️ Competitor Copies Your Feature",
            description: "A rival launched a similar product with aggressive pricing.",
            options: [
                GameEventOption(
                    title: "Differentiate with Quality",
                    description: "Invest in customer experience instead of a price war.",
                    cashEffect: -9_000,
                    companyValueEffect: 20_000,
                    customerEffect: 250,
                    researchEffect: 30,
                    reputationEffect: 3,
                    marketShareEffect: 0.3,
                    satisfactionEffect: 6
                ),
                GameEventOption(
                    title: "Match the Discount",
                    description: "Protect share but cheapen the brand.",
                    cashEffect: -3_000,
                    companyValueEffect: -10_000,
                    customerEffect: 900,
                    researchEffect: 0,
                    reputationEffect: -2,
                    marketShareEffect: 0.8,
                    satisfactionEffect: 1
                )
            ]
        ),

        GameEvent(
            title: "🏛️ Policy Roundtable Invite",
            description: "Regulators asked your company to join an AI policy working group.",
            options: [
                GameEventOption(
                    title: "Take a Public Leadership Role",
                    description: "Gain trust and reputation, but slow research velocity.",
                    cashEffect: -5_000,
                    companyValueEffect: 30_000,
                    customerEffect: 150,
                    researchEffect: -30,
                    reputationEffect: 5,
                    marketShareEffect: 0.2,
                    satisfactionEffect: 3
                ),
                GameEventOption(
                    title: "Send Legal Counsel",
                    description: "Keep leaders focused while staying represented.",
                    cashEffect: -2_500,
                    companyValueEffect: 10_000,
                    customerEffect: 0,
                    researchEffect: 0,
                    reputationEffect: 1,
                    marketShareEffect: 0,
                    satisfactionEffect: 0
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
