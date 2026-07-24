import SwiftUI

struct CEOMessageRow: View {

    let message: CEOMessage

    var color: Color {

        switch message.priority {

        case .critical:
            return .red

        case .attention:
            return .orange

        case .opportunity:
            return .green

        case .industry:
            return .blue

        }

    }

    var icon: String {

        switch message.priority {

        case .critical:
            return "exclamationmark.triangle.fill"

        case .attention:
            return "bell.fill"

        case .opportunity:
            return "sparkles"

        case .industry:
            return "newspaper.fill"

        }

    }

    var body: some View {

        HStack(alignment: .top, spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(color)

            VStack(alignment: .leading, spacing: 4) {

                Text(message.title)
                    .font(.headline)

                Text(message.message)
                    .font(.caption)
                    .foregroundStyle(.secondary)

            }

            Spacer()

        }

    }

}

#Preview {

    CEOMessageRow(

        message: CEOMessage(
            priority: .critical,
            title: "Low Cash",
            message: "Cash reserves are running low."
        )

    )

}
//  CEOMessageRow.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/4/26.
//

