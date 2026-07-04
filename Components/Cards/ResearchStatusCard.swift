import SwiftUI

struct ResearchStatusCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        GroupBox {

            if let activeID = game.company.activeResearch,
               let tech = game.company.technologies.first(where: { $0.id == activeID }) {

                VStack(alignment: .leading, spacing: 12) {

                    Text(tech.name)
                        .font(.headline)

                    ProgressView(
                        value: tech.progress,
                        total: tech.requiredResearch
                    )
                    .tint(.purple)

                    Text(
                        "\(Int(tech.progress)) / \(Int(tech.requiredResearch)) RP"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text("\(Int((tech.progress / tech.requiredResearch) * 100))% Complete")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.purple)

                }

            } else {

                VStack(spacing: 12) {

                    Image(systemName: "brain")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Text("No Active Research")
                        .foregroundStyle(.secondary)

                }

            }

        } label: {

            Label(
                "Active Research",
                systemImage: "brain.head.profile"
            )

        }

    }

}

#Preview {

    ResearchStatusCard()
        .environment(GameManager())

}
//  ResearchStatusCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

