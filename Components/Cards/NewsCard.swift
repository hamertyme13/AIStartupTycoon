import SwiftUI

struct NewsCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Label(
                "Latest News",
                systemImage: "newspaper.fill"
            )
            .font(.headline)
            .foregroundStyle(RogueCircuitTheme.electricCyan)

            Divider()

            VStack(alignment: .leading, spacing: 10) {

                Text(game.company.latestNews)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                if let latest = game.company.notifications.first {

                    Text("Latest Notification")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(latest.title)
                        .bold()

                    Text(latest.message)
                        .font(.caption)

                }

            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

}

#Preview {

    NewsCard()
        .environment(GameManager())

}
//  NewsCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/2/26.
//
