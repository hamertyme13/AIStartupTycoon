import Foundation

extension GameManager {
    
    // MARK: - Monthly Competitor Simulation

    func simulateCompetitors() {

        for index in company.competitors.indices {

            applyMonthlyCompetitorGrowth(at: index)

            simulateCompetitor(at: index)

            releaseCompetitorModelIfReady(at: index)

        }

        normalizeMarketShare()

    }
    
    // MARK: - Individual Competitor Turn
    
    private func simulateCompetitor(
        at index: Int
    ) {

        let personality =
            company.competitors[index].ceo.personality

        switch personality {

        case .scientist:

            competitorResearch(index)

        case .engineer:

            competitorHire(index)

        case .dealmaker:

            competitorFunding(index)

        case .marketer:

            competitorMarketing(index)

        case .visionary:

            competitorBalancedGrowth(index)

        }

    }
    
    // MARK: - Actions

    private func applyMonthlyCompetitorGrowth(
        at index: Int
    ) {

        company.competitors[index].cash +=
            company.competitors[index].revenue

        company.competitors[index].valuation +=
            Double.random(in: 20_000...80_000)

        payCompetitorBaselineResearch(at: index)

        if Int.random(in: 1...100) <= 30 {

            company.competitors[index].employees += 1

        }

        if Int.random(in: 1...100) <= 15 {

            company.competitors[index].products += 1

            company.competitors[index].revenue +=
                Double.random(in: 200...800)

            company.competitors[index].marketShare += 0.2

        }

        let change = Double.random(in: -1.5...1.5)

        company.competitors[index].marketShare =
            max(2, company.competitors[index].marketShare + change)

    }
    
    private func competitorHire(
        _ index: Int
    ) {

        company.competitors[index].employees += 1
        company.competitors[index].rivalryHeat =
            min(100, company.competitors[index].rivalryHeat + 4)
        company.competitors[index].signatureMove = "Hired senior engineering talent"

        company.competitors[index].cash -= 5_000

        company.competitors[index].valuation += 10_000
        
        competitorNews(
                competitor: company.competitors[index],
                message: "hired another engineer."
            )

    }
    
    private func competitorBalancedGrowth(
        _ index: Int
    ) {

        company.competitors[index].employees += 1

        company.competitors[index].revenue += 150

        company.competitors[index].valuation += 20_000
        company.competitors[index].signatureMove = "Expanded steadily across products"
        
        competitorNews(
                competitor: company.competitors[index],
                message: "continued its steady expansion."
            )

    }
    
    private func competitorFunding(
        _ index: Int
    ) {

        company.competitors[index].cash += 250_000

        company.competitors[index].valuation += 500_000
        company.competitors[index].rivalryHeat =
            min(100, company.competitors[index].rivalryHeat + 6)
        company.competitors[index].signatureMove = "Raised fresh capital"
        
        competitorNews(
                competitor: company.competitors[index],
                message: "raised a new round of funding."
            )

    }
    
    private func competitorMarketing(
        _ index: Int
    ) {

        company.competitors[index].marketShare += 0.5

        company.marketShare = max(
            0,
            company.marketShare - 0.5
        )
        company.competitors[index].rivalryHeat =
            min(100, company.competitors[index].rivalryHeat + 8)
        company.competitors[index].signatureMove = "Attacked your market share"
        
        competitorNews(
                competitor: company.competitors[index],
                message: "launched a major marketing campaign."
            )

    }
    
    private func competitorResearch(
        _ index: Int
    ) {

        let cost = competitorResearchPushCost(at: index)

        guard company.competitors[index].cash >= cost else {

            company.competitors[index].valuation =
                max(0, company.competitors[index].valuation - 15_000)

            competitorNews(
                competitor: company.competitors[index],
                message: "slowed its AI research after burning through its lab budget."
            )

            return

        }

        company.competitors[index].cash -= cost

        company.competitors[index].researchProgress += 25

        company.competitors[index].valuation += cost * 1.5
        company.competitors[index].signatureMove = "Pushed frontier research"
        
        competitorNews(
               competitor: company.competitors[index],
               message: "expanded its AI research efforts despite higher lab costs."
           )

    }

    private func payCompetitorBaselineResearch(
        at index: Int
    ) {

        let cost = competitorMonthlyResearchCost(at: index)
        let progress = Double.random(in: 2...8)

        if company.competitors[index].cash >= cost {

            company.competitors[index].cash -= cost
            company.competitors[index].researchProgress += progress

        } else {

            let fundingRatio =
                max(0.15, company.competitors[index].cash / max(cost, 1))

            company.competitors[index].cash = 0
            company.competitors[index].researchProgress +=
                progress * fundingRatio
            company.competitors[index].valuation =
                max(0, company.competitors[index].valuation - cost)
            company.competitors[index].marketShare =
                max(2, company.competitors[index].marketShare - 0.1)

        }

    }

    private func competitorMonthlyResearchCost(
        at index: Int
    ) -> Double {

        let competitor = company.competitors[index]

        return 1_500 +
            Double(competitor.employees) * 350 +
            Double(competitor.aiModelsReleased + 1) * 1_200

    }

    private func competitorResearchPushCost(
        at index: Int
    ) -> Double {

        competitorMonthlyResearchCost(at: index) * 3

    }

    private func releaseCompetitorModelIfReady(
        at index: Int
    ) {

        guard company.competitors[index].researchProgress >=
            company.competitors[index].nextModelProgress else {

            return

        }

        company.competitors[index].researchProgress = 0

        company.competitors[index].aiModelsReleased += 1

        company.competitors[index].aiRating +=
            Double.random(in: 4...8)

        if let modelName = CompetitorModels.names.randomElement() {

            company.competitors[index].currentModel = modelName

        }

        competitorNews(
            competitor: company.competitors[index],
            message: "released \(company.competitors[index].currentModel)."
        )
        company.competitors[index].rivalryHeat =
            min(100, company.competitors[index].rivalryHeat + 10)
        company.competitors[index].signatureMove =
            "Released \(company.competitors[index].currentModel)"

    }

    private func normalizeMarketShare() {

        let competitorShare = company.competitors.reduce(0) {

            $0 + $1.marketShare

        }

        company.marketShare =
            max(1, min(95, 100 - competitorShare))

    }
    
    private func competitorNews(
        competitor: Competitor,
        message: String
    ) {

        addNotification(
            title: "📰 Industry News",
            message: "\(competitor.name) \(message)"
        )

    }

}
//  GameManager+CompetitorSimulation.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/4/26.
//
