import SwiftUI

struct NotificationCenterView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 16) {

                    ForEach(game.company.notifications) {

                        NotificationRow(notification: $0)

                    }

                }
                .padding()

            }
            .navigationTitle("Notifications")

        }

    }

}

#Preview {

    NotificationCenterView()
        .environment(GameManager())

}
//  NotificationCenterView.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//

