import SwiftUI

struct ObjectivesCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Label(
                "Company Objectives",
                systemImage: "target"
            )
            .font(.headline)

            Divider()

            if let outcome = game.gameOutcome {

                VStack(alignment: .leading, spacing: 8) {

                    Text(outcome.title)
                        .font(.subheadline)
                        .bold()

                    Text(outcome.message)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }
                .padding(.vertical, 4)

                Divider()

            }

            Text("Milestones")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            objectiveRow(
                completed: game.company.employees.count >= 5,
                text: "Hire 5 employees"
            )

            objectiveRow(
                completed: game.company.products.contains {
                    $0.level >= 5
                },
                text: "Scale one product to Level 5"
            )

            objectiveRow(
                completed: game.company.monthlyRevenue >= 10_000,
                text: "Reach $10,000 monthly revenue"
            )

            objectiveRow(
                completed: game.company.hasUnlockedTechnology("Image Generation"),
                text: "Unlock Image Generation"
            )

            objectiveRow(
                completed: game.company.companyValue >= 1_000_000,
                text: "Reach $1M valuation"
            )

            objectiveRow(
                completed: game.company.customerSatisfaction >= 85,
                text: "Reach 85% customer satisfaction"
            )

            objectiveRow(
                completed: game.company.totalCustomers >= 10_000,
                text: "Serve 10,000 customers"
            )

            objectiveRow(
                completed: game.company.releasedAIModelCount >= 2,
                text: "Release 2 AI models"
            )

            objectiveRow(
                completed: game.company.unlockedTechnologyCount >= 4,
                text: "Unlock 4 technologies"
            )

            objectiveRow(
                completed: game.company.monthlyProfit >= 25_000,
                text: "Earn $25,000 monthly profit"
            )

            Divider()

            Text("Victory Routes")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            objectiveRow(
                completed: game.company.marketShare >= 60 &&
                    game.company.monthlyRevenue >= 100_000,
                text: "Dominate AI: 60% share and $100K monthly revenue"
            )

            objectiveRow(
                completed: game.company.hasUnlockedTechnology(
                    "Artificial General Intelligence"
                ) && game.company.companyValue >= 100_000_000,
                text: "Build a $100M AGI company"
            )

            objectiveRow(
                completed: game.company.activeInvestors.isEmpty &&
                    game.company.founderOwnership >= 90 &&
                    game.company.monthlyProfit >= 50_000 &&
                    game.company.cash >= 500_000,
                text: "Bootstrap to $50K profit with founder control"
            )

            objectiveRow(
                completed: game.company.releasedAIModelCount >= 4 &&
                    game.company.unlockedTechnologyCount >= 5 &&
                    game.company.companyValue >= 50_000_000,
                text: "Become a frontier research lab"
            )

            objectiveRow(
                completed: game.company.companyValue >= 500_000_000 &&
                    game.company.monthlyProfit >= 100_000 &&
                    game.company.founderOwnership >= 35,
                text: "IPO with $500M valuation, $100K profit, and 35% ownership"
            )

            objectiveRow(
                completed: game.company.companyValue >= 250_000_000 &&
                    game.company.cash >= 5_000_000 &&
                    game.company.customerSatisfaction >= 88,
                text: "Earn a premium acquisition offer"
            )

            objectiveRow(
                completed: game.company.companyValue >= 1_000_000_000 &&
                    game.company.activeInvestors.count >= 2 &&
                    game.company.monthlyRevenue >= 250_000,
                text: "Build a venture-backed unicorn"
            )

            objectiveRow(
                completed: game.company.unlockedProductCount >=
                    game.company.products.count &&
                    game.company.totalCustomers >= 100_000 &&
                    game.company.customerSatisfaction >= 90,
                text: "Create a beloved AI product ecosystem"
            )

            Divider()

            Text("Avoid")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)

            riskRow(
                safe: game.company.cash >= -25_000,
                text: "Bankruptcy below -$25,000 cash"
            )

            riskRow(
                safe: game.company.founderOwnership >= 20,
                text: "Loss of control below 20% ownership"
            )

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

    @ViewBuilder
    func objectiveRow(
        completed: Bool,
        text: String
    ) -> some View {

        HStack {

            Image(systemName:
                completed
                ? "checkmark.circle.fill"
                : "circle"
            )
            .foregroundStyle(
                completed
                ? .green
                : .secondary
            )

            Text(text)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(completed ? "Complete" : "Incomplete"): \(text)")

    }

    @ViewBuilder
    func riskRow(
        safe: Bool,
        text: String
    ) -> some View {

        HStack {

            Image(systemName:
                safe
                ? "shield.checkered"
                : "exclamationmark.triangle.fill"
            )
            .foregroundStyle(
                safe
                ? Color.secondary
                : Color.red
            )

            Text(text)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(safe ? "Safe" : "At risk"): \(text)")

    }

}

#Preview {

    ObjectivesCard()
        .environment(GameManager())

}
//  ObjectivesCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//
