import SwiftUI

struct CompanyHealthCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Label(
                "Company Health",
                systemImage: "heart.text.square.fill"
            )
            .font(.headline)
            .foregroundStyle(RogueCircuitTheme.signalGreen)

            Divider()

            VStack(alignment: .leading, spacing: 12) {

                ProgressBar(
                    progress: game.company.companyHealth
                )

                HStack {

                    Text("Health Score")

                    Spacer()

                    Text("\(Int(game.company.companyHealth * 100))%")
                        .bold()

                }

                Divider()

                HStack {

                    Text("Stage")

                    Spacer()

                    Text(game.company.campaignStage.rawValue)
                        .bold()

                }

                HStack {

                    Text("Scenario")

                    Spacer()

                    Text(game.company.selectedScenario.rawValue)
                        .bold()

                }

                HStack {

                    Text("Satisfaction")

                    Spacer()

                    Text("\(game.company.customerSatisfaction)%")
                        .bold()
                        .foregroundStyle(
                            game.company.customerSatisfaction >= 60
                            ? .green
                            : .orange
                        )

                }

                if let event = game.company.activeWorldEvent {

                    Label(
                        event.title,
                        systemImage: "globe.americas.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.blue)

                }

            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

}

#Preview {

    CompanyHealthCard()
        .environment(GameManager())

}
//  CompanyHealthCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
