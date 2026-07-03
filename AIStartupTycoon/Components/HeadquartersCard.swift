import SwiftUI

struct HeadquartersCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        GroupBox {

            VStack(alignment: .leading, spacing: 10) {

                Text(game.company.currentOffice.icon)
                    .font(.system(size: 40))

                Text(game.company.currentOffice.name)
                    .font(.headline)

                Divider()

                Label(
                    "+\(Int(game.company.currentOffice.productivityBonus * 100))% Productivity",
                    systemImage: "bolt.fill"
                )

                Label(
                    "+\(Int(game.company.currentOffice.researchBonus * 100))% Research",
                    systemImage: "brain.head.profile"
                )

                Label(
                    "$\(Int(game.company.currentOffice.monthlyRent).formatted()) Rent",
                    systemImage: "dollarsign.circle"
                )

            }

        } label: {

            Label(
                "Headquarters",
                systemImage: "building.2.fill"
            )

        }

    }

}

#Preview {

    HeadquartersCard()
        .environment(GameManager())

}
//  HeadquartersCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

