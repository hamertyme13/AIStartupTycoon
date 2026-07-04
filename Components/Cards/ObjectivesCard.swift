import SwiftUI

struct ObjectivesCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Label(
                "Current Objectives",
                systemImage: "target"
            )
            .font(.headline)

            Divider()

            objectiveRow(
                completed: game.company.employees.count >= 5,
                text: "Hire 5 employees"
            )

            objectiveRow(
                completed: game.company.monthlyRevenue >= 10_000,
                text: "Reach $10,000 monthly revenue"
            )

            objectiveRow(
                completed: game.company.hasUnlockedTechnology("Image Generation"),
                text: "Unlock Image Generation"
            )

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )

    }

    @ViewBuilder
    func objectiveRow(
        completed: Bool,
        text: String
    ) -> some View {

        HStack {

            Image(systemName:
                completed
                ? "checkmark.circle.fill"
                : "circle"
            )
            .foregroundStyle(
                completed
                ? .green
                : .secondary
            )

            Text(text)

            Spacer()

        }

    }

}

#Preview {

    ObjectivesCard()
        .environment(GameManager())

}
//  ObjectivesCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//

