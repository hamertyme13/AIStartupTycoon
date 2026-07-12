import SwiftUI

struct CashFlowCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Label(
                "Cash Flow",
                systemImage: "dollarsign.circle.fill"
            )
            .font(.headline)

            Divider()

            ViewThatFits(in: .horizontal) {

                HStack(alignment: .top, spacing: 12) {

                    cashMetric(
                        title: "Cash",
                        value: "$\(Int(game.company.cash).formatted())",
                        color: RogueCircuitTheme.text,
                        alignment: .leading
                    )

                    Spacer(minLength: 12)

                    cashMetric(
                        title: "Monthly Profit",
                        value: "$\(Int(game.company.monthlyProfit).formatted())",
                        color: game.company.monthlyProfit >= 0
                        ? .green
                        : .red,
                        alignment: .trailing
                    )

                }

                VStack(alignment: .leading, spacing: 12) {

                    cashMetric(
                        title: "Cash",
                        value: "$\(Int(game.company.cash).formatted())",
                        color: RogueCircuitTheme.text,
                        alignment: .leading
                    )

                    cashMetric(
                        title: "Monthly Profit",
                        value: "$\(Int(game.company.monthlyProfit).formatted())",
                        color:
                        game.company.monthlyProfit >= 0
                        ? .green
                        : .red,
                        alignment: .leading
                    )

                }

            }

            Divider()

            HStack {

                Text("Runway")

                Spacer()

                Text(
                    "\(Int(game.company.runwayMonths)) months"
                )
                .bold()

            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

    private func cashMetric(
        title: String,
        value: String,
        color: Color,
        alignment: HorizontalAlignment
    ) -> some View {

        VStack(alignment: alignment, spacing: 4) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3)
                .bold()
                .foregroundStyle(color)
                .lineLimit(1)
                .minimumScaleFactor(0.62)

        }

    }

}

#Preview {

    CashFlowCard()
        .environment(GameManager())

}
//  CashFlowCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//
