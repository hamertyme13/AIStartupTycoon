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

            HStack {

                VStack(alignment: .leading) {

                    Text("Cash")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("$\(Int(game.company.cash).formatted())")
                        .font(.title2)
                        .bold()

                }

                Spacer()

                VStack(alignment: .trailing) {

                    Text("Monthly Profit")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(
                        "$\(Int(game.company.monthlyProfit).formatted())"
                    )
                    .font(.title3)
                    .bold()
                    .foregroundStyle(
                        game.company.monthlyProfit >= 0
                        ? .green
                        : .red
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
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )

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

