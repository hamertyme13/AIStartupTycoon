import SwiftUI

struct ResearchCard: View {

    @Environment(GameManager.self) private var game

    let technology: Technology
    let index: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text(technology.name)
                .font(.title3)
                .bold()

            Text(technology.description)
                .foregroundStyle(.secondary)

            ProgressView(
                value: technology.progress,
                total: technology.requiredResearch
            )

            Text(
                "\(Int(technology.progress)) / \(Int(technology.requiredResearch)) RP"
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            HStack {

                Label("Research Cost", systemImage: "creditcard.fill")

                Spacer()

                Text("$\(Int(technology.monthlyResearchCost))/mo")
                    .bold()

            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if technology.unlocked {

                Label(
                    "Unlocked",
                    systemImage: "checkmark.circle.fill"
                )
                .foregroundStyle(.green)

            } else {

                Button("Start Research") {

                    game.startResearch(index: index)

                }
                .buttonStyle(.borderedProminent)

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

    ResearchCard(
        technology: Technology(
            name: "Image Generation",
            description: "Create AI images.",
            requiredResearch: 250
        ),
        index: 0
    )
}
//  ResearchCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
