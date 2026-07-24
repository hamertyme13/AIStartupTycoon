import SwiftUI

struct ExecutiveSummaryCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        GroupBox("Executive Summary") {

            VStack(spacing: 14) {

                HStack {

                    Label("Employees", systemImage: "person.3.fill")

                    Spacer()

                    Text("\(game.company.employees.count)")
                        .bold()

                }

                HStack {

                    Label("Products", systemImage: "shippingbox.fill")

                    Spacer()

                    Text(
                        "\(game.company.products.filter { $0.unlocked }.count)"
                    )
                    .bold()

                }

                HStack {

                    Label("Cash", systemImage: "dollarsign.circle.fill")

                    Spacer()

                    Text("$\(Int(game.company.cash).formatted())")
                        .bold()

                }

                HStack {

                    Label("Founder Ownership", systemImage: "building.columns.fill")

                    Spacer()

                    Text("\(Int(game.company.founderOwnership))%")
                        .bold()

                }

            }

        }

    }

}

#Preview {

    ExecutiveSummaryCard()
        .environment(GameManager())

}
//  ExecutiveSummaryCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/4/26.
//

