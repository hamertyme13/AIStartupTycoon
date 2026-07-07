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

        company.competitors[index].researchProgress +=
            Double.random(in: 2...8)

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
        
        competitorNews(
                competitor: company.competitors[index],
                message: "launched a major marketing campaign."
            )

    }
    
    private func competitorResearch(
        _ index: Int
    ) {

        company.competitors[index].researchProgress += 25
        
        competitorNews(
               competitor: company.competitors[index],
               message: "expanded its AI research efforts."
           )

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
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//
