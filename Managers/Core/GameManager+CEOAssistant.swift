import Foundation

extension GameManager {

    func clearCEOBriefing() {

        company.ceoBriefing.removeAll()

    }

    func addCEOMessage(
        priority: CEOMessage.Priority,
        title: String,
        message: String
    ) {

        company.ceoBriefing.append(

            CEOMessage(
                priority: priority,
                title: title,
                message: message
            )

        )

    }
    
    func generateCEOBriefing() {

        clearCEOBriefing()

        if company.monthlyProfit < 0 {

            addCEOMessage(
                priority: .critical,
                title: "Negative Cash Flow",
                message: "Your company is losing money."
            )

        }

        if company.cash < 25_000 {

            addCEOMessage(
                priority: .critical,
                title: "Low Cash",
                message: "Cash reserves are getting low."
            )

        }

        if company.activeInvestors.isEmpty {

            addCEOMessage(
                priority: .opportunity,
                title: "Raise Capital",
                message: "Consider seeking investors."
            )

        }

        if company.employees.count < 5 {

            addCEOMessage(
                priority: .attention,
                title: "Hiring",
                message: "Your team is still very small."
            )

        }

    }

}
//  GameManager+CEOAssistant.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//

