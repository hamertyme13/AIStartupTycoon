import SwiftUI

struct MarketingView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 25) {

                    StatCard(
                        title: "Customer Satisfaction",
                        value: "\(game.company.customerSatisfaction)%",
                        color: game.company.customerSatisfaction >= 70
                            ? RogueCircuitTheme.signalGreen
                            : .orange
                    )

                    StatCard(
                        title: "⭐ Reputation",
                        value: "\(game.company.reputation)",
                        color: .yellow
                    )

                    StatCard(
                        title: "📈 Market Share",
                        value: "\(Int(game.company.marketShare))%",
                        color: .blue
                    )

                    StatCard(
                        title: "Support Capacity",
                        value: "\(Int(game.company.supportCapacity * 100))%",
                        color: game.company.supportCapacity >= 1
                            ? RogueCircuitTheme.signalGreen
                            : RogueCircuitTheme.electricCyan
                    )

                    VStack(alignment: .leading, spacing: 12) {

                        Label(
                            "Customer Success",
                            systemImage: "heart.text.square.fill"
                        )
                        .font(.headline)

                        Text("Fund a support sprint to recover satisfaction, reduce churn risk, and protect reputation. Assigning employees to Product and Engineering improves long-term support capacity.")
                            .font(.caption)
                            .foregroundStyle(RogueCircuitTheme.mutedText)
                            .fixedSize(horizontal: false, vertical: true)

                        Button {

                            game.launchCustomerSuccessSprint()

                        } label: {

                            Label(
                                "Run Sprint ($\(Int(game.company.customerSuccessCost).formatted()))",
                                systemImage: "wrench.and.screwdriver.fill"
                            )
                            .frame(maxWidth: .infinity)

                        }
                        .buttonStyle(.borderedProminent)
                        .tint(RogueCircuitTheme.signalGreen)
                        .disabled(game.company.cash < game.company.customerSuccessCost)
                        .accessibilityHint(
                            "Improves customer satisfaction and lowers churn risk."
                        )

                    }
                    .padding()
                    .rogueCircuitCard(cornerRadius: 20)

                    Button {

                        game.launchMarketingCampaign()

                    } label: {

                        Label(
                            "Launch Campaign ($2,000)",
                            systemImage: "megaphone.fill"
                        )
                        .frame(maxWidth: .infinity)

                    }
                    .buttonStyle(.borderedProminent)
                    .tint(RogueCircuitTheme.electricCyan)

                }
                .padding()

            }
            .navigationTitle("Marketing")

        }

    }

}

#Preview {

    MarketingView()
        .environment(GameManager())

}
//  MarketingView.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//
