import SwiftUI

struct CompetitorCard: View {

    let competitor: Competitor

    var body: some View {

        GroupBox {

            VStack(alignment: .leading, spacing: 12) {

                Text(competitor.name)
                    .font(.title3)
                    .bold()

                Divider()

                HStack {

                    Label("Employees", systemImage: "person.3.fill")

                    Spacer()

                    Text("\(competitor.employees)")

                }

                HStack {

                    Label("Products", systemImage: "shippingbox.fill")

                    Spacer()

                    Text("\(competitor.products)")

                }

                HStack {

                    Label("Revenue", systemImage: "chart.line.uptrend.xyaxis")

                    Spacer()

                    Text("$\(Int(competitor.revenue).formatted())")

                }

                HStack {

                    Label("Valuation", systemImage: "building.columns")

                    Spacer()

                    Text("$\(Int(competitor.valuation).formatted())")

                }

                Divider()

                HStack {

                    Label("Rivalry", systemImage: "flame.fill")

                    Spacer()

                    Text("\(competitor.rivalryHeat)%")
                        .foregroundStyle(
                            competitor.rivalryHeat >= 60 ? .orange : .secondary
                        )

                }

                Text(competitor.signatureMove)
                    .font(.caption)
                    .foregroundStyle(.secondary)

            }

        }

    }

}
//  CompetitorCard.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
