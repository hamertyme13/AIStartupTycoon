import SwiftUI

struct CompanyHealthCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        GroupBox {

            VStack(alignment: .leading, spacing: 12) {

                ProgressBar(
                    progress: game.company.companyHealth
                )

                HStack {

                    Text("Health Score")

                    Spacer()

                    Text("\(Int(game.company.companyHealth * 100))%")
                        .bold()

                }

            }

        } label: {

            Label(
                "Company Health",
                systemImage: "heart.text.square.fill"
            )
            .foregroundStyle(.red)

        }

    }

}

#Preview {

    CompanyHealthCard()
        .environment(GameManager())

}
//  CompanyHealthCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

