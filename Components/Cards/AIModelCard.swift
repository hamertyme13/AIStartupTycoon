import SwiftUI

struct AIModelCard: View {
    
    @Environment(GameManager.self) private var game

    let model: AIModel

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack {

                Image(systemName: "cpu.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.purple)

                VStack(alignment: .leading) {

                    Text(model.name)
                        .font(.title3)
                        .bold()

                    Text(model.description)
                        .foregroundStyle(.secondary)

                }

                Spacer()

            }

            Divider()

            Label(
                model.requiredTechnology,
                systemImage: "brain.head.profile"
            )

            HStack {

                Text("Training Cost")

                Spacer()

                Text("$\(Int(model.trainingCost).formatted())")

            }

            HStack {

                Text("Revenue Bonus")

                Spacer()

                Text("+$\(Int(model.revenueBonus))/mo")
                    .foregroundStyle(.green)

            }

            HStack {

                Text("Market Share")

                Spacer()

                Text("+\(Int(model.marketShareBonus))%")
                    .foregroundStyle(.cyan)

            }

            Divider()

            switch model.status {

            case .locked:

                Label(
                    "Locked",
                    systemImage: "lock.fill"
                )
                .foregroundStyle(.secondary)

            case .readyToTrain:

                VStack(alignment: .leading, spacing: 12) {

                    Label(
                        "Ready to Train",
                        systemImage: "hammer.fill"
                    )
                    .foregroundStyle(.yellow)

                    Button("Begin Training") {

                        game.beginTraining(modelID: model.id)

                    }
                    .buttonStyle(.borderedProminent)

                }

            case .training:

                VStack(alignment: .leading, spacing: 8) {

                    Label(
                        "Training...",
                        systemImage: "cpu.fill"
                    )
                    .foregroundStyle(.blue)

                    ProgressView(
                        value: model.trainingProgress,
                        total: 100
                    )

                    Text("\(Int(model.trainingProgress))%")
                        .font(.caption)

                }

            case .readyToRelease:

                VStack(alignment: .leading, spacing: 12) {

                    Label(
                        "Ready to Release",
                        systemImage: "rocket.fill"
                    )
                    .foregroundStyle(.orange)

                    Button {

                        game.releaseModel(modelID: model.id)

                    } label: {

                        Label(
                            "Release Model",
                            systemImage: "paperplane.fill"
                        )

                    }
                    .buttonStyle(.borderedProminent)

                }

            case .released:

                Label(
                    "Released",
                    systemImage: "checkmark.seal.fill"
                )
                .foregroundStyle(.green)

            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }

}

#Preview {

    AIModelCard(
        model: AIModel(
            name: "Neuron-1",
            description: "Conversational AI",
            requiredTechnology: "Chatbots",
            trainingCost: 25000,
            requiredResearch: 100,
            revenueBonus: 500,
            marketShareBonus: 2,
            valuationBonus: 100000
        )
    )

}
//  AIModelCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

