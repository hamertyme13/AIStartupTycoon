import SwiftUI

struct MarketView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 20) {
                    
                    MarketShareCard(
                        name: game.company.name,
                        share: game.company.marketShare,
                        color: .blue
                    )

                    ForEach(game.company.competitors) { competitor in

                        CompetitorCard(
                            competitor: competitor
                        )
                        
                        MarketShareCard(
                            name: competitor.name,
                            share: competitor.marketShare,
                            color: .gray
                        )

                    }

                }
                .padding()

            }
            .navigationTitle("Market")

        }

    }

}

#Preview {

    MarketView()
        .environment(GameManager())

}
//  MarketView.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//

