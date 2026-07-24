import SwiftUI

struct BoardView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    GroupBox("Founder") {

                        HStack {

                            VStack(alignment: .leading) {

                                Text("You")
                                    .font(.headline)

                                Text("Founder & CEO")
                                    .foregroundStyle(.secondary)

                            }

                            Spacer()

                            Text("\(Int(game.company.founderOwnership))%")
                                .font(.title2)
                                .bold()

                        }

                    }

                    ForEach(game.company.activeInvestors) { investor in

                        GroupBox {

                            VStack(alignment: .leading, spacing: 12) {

                                HStack {

                                    VStack(alignment: .leading) {

                                        Text(investor.name)
                                            .font(.headline)

                                        Text(investor.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        Text(investor.personality.rawValue)
                                            .font(.caption)
                                            .foregroundStyle(RogueCircuitTheme.signalGreen)

                                    }

                                    Spacer()

                                    Text("\(Int(investor.equity))%")
                                        .bold()

                                }

                                Divider()

                                HStack {

                                    Text("Focus")

                                    Spacer()

                                    Text(investor.focus.rawValue)

                                }

                                HStack {

                                    Text("Contribution")

                                    Spacer()

                                    Text(investor.contribution.title)
                                        .multilineTextAlignment(.trailing)

                                }

                                HStack {

                                    Text("Relationship")

                                    Spacer()

                                    Text("\(investor.relationship)%")
                                        .foregroundStyle(
                                            investor.relationship >= 65
                                            ? RogueCircuitTheme.signalGreen
                                            : .orange
                                        )

                                }

                                Text(investor.contribution.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                if let investedDate = investor.investedDate {

                                    HStack {

                                        Text("Joined")

                                        Spacer()

                                        Text(investedDate)

                                    }

                                    .font(.caption)

                                }

                            }

                        }

                    }

                }

                .padding()

            }

            .navigationTitle("Board")

        }

    }

}

#Preview {

    BoardView()
        .environment(GameManager())

}
//  BoardView.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/4/26.
//
