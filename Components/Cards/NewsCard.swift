import SwiftUI

struct NewsCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        GroupBox {

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

        } label: {

            Label(
                "Latest News",
                systemImage: "newspaper.fill"
            )

        }

    }

}

#Preview {

    NewsCard()
        .environment(GameManager())

}
//  NewsCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

