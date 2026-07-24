import SwiftUI

struct InvestorsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    ForEach(game.company.investors.indices, id: \.self) { index in

                        InvestorCard(
                            investor: game.company.investors[index]
                        ) {

                            withAnimation {

                                game.acceptInvestment(index: index)

                            }

                        }

                    }

                }
                .padding()

            }

            .navigationTitle("Investors")

        }

    }

}

#Preview {

    InvestorsView()
        .environment(GameManager())

}
//  Untitled.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/4/26.
//

