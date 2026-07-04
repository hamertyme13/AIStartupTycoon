import SwiftUI

struct MarketingView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 25) {

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

