import SwiftUI

struct CompanyCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        GroupBox {

            VStack(spacing: 16) {

                HStack {

                    Label(
                        "Employees",
                        systemImage: "person.3.fill"
                    )

                    Spacer()

                    Text("\(game.company.employees.count)")
                        .bold()

                }

                HStack {

                    Label(
                        "Products",
                        systemImage: "shippingbox.fill"
                    )

                    Spacer()

                    Text("\(game.company.products.filter { $0.unlocked }.count)")
                        .bold()

                }

                HStack {

                    Label(
                        "Founder Ownership",
                        systemImage: "building.columns.fill"
                    )

                    Spacer()

                    Text("\(Int(game.company.founderOwnership))%")
                        .bold()

                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {

                    HStack {

                        Label(
                            "Market Share",
                            systemImage: "chart.pie.fill"
                        )

                        Spacer()

                        Text("\(Int(game.company.marketShare))%")
                            .bold()
                            .foregroundStyle(.cyan)

                    }

                    ProgressView(
                        value: game.company.marketShare,
                        total: 100
                    )
                    .tint(.cyan)

                }

            }

        } label: {

            Label(
                "Company",
                systemImage: "building.2.fill"
            )

        }

    }

}

#Preview {

    CompanyCard()
        .environment(GameManager())

}
//  CompanyCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//

