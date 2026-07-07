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

            Divider()

            Text("Endgame")
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
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )

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

            Spacer()

        }

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

            Spacer()

        }

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
