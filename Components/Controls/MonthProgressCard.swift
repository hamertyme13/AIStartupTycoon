import SwiftUI

struct MonthProgressCard: View {

    let elapsed: Int
    let total: Int

    private var progress: Double {
        Double(elapsed) / Double(total)
    }

    private var remaining: Int {
        max(total - elapsed, 0)
    }

    private var timeString: String {

        let minutes = remaining / 60
        let seconds = remaining % 60

        return String(format: "%d:%02d", minutes, seconds)

    }

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Label(
                "Next Month",
                systemImage: "calendar"
            )
            .font(.headline)
            .foregroundStyle(RogueCircuitTheme.signalGreen)

            Divider()

            VStack(spacing: 16) {

                ProgressView(value: progress)

                Text("\(Int(progress * 100))% Complete")
                    .font(.headline)

                Text("\(timeString) remaining")
                    .foregroundStyle(.secondary)

            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

}

#Preview {

    MonthProgressCard(
        elapsed: 35,
        total: 120
    )

}
//  MonthProgressCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
