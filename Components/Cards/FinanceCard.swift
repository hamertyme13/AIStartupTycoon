import SwiftUI

struct FinanceCard: View {

    @Environment(GameManager.self) private var game
    
    var runwayText: String {

        let runway = game.company.runwayMonths

        switch runway {

        case 12...:
            return "12+ Months"

        case 6..<12:
            return String(format: "%.1f Months", runway)

        case 1..<6:
            return String(format: "%.1f Months", runway)

        default:
            let days = Int(runway * 30)
            return "\(days) Days"

        }

    }
    
    var body: some View {

        GroupBox {

            VStack(spacing: 16) {

                FinanceRow(
                    title: "Cash",
                    value: "$\(Int(game.company.cash).formatted())",
                    icon: "dollarsign.circle.fill",
                    color: .green
                )

                FinanceRow(
                    title: "Revenue",
                    value: "$\(Int(game.company.monthlyRevenue).formatted())",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )

                FinanceRow(
                    title: "Profit",
                    value: "$\(Int(game.company.monthlyProfit).formatted())",
                    icon: "arrow.up.right.circle.fill",
                    color: game.company.monthlyProfit >= 0 ? .green : .red
                )

                FinanceRow(
                    title: "Burn Rate",
                    value: "$\(Int(game.company.burnRate).formatted())",
                    icon: "flame.fill",
                    color: .orange
                )
                
                FinanceRow(
                    title: "Runway",
                    value: runwayText,
                    icon: "airplane",
                    color: .purple
                )

            }

        } label: {

            Label("Financial Overview",
                  systemImage: "chart.bar.doc.horizontal.fill")
                .font(.headline)

        }

    }

}
//  FinanceCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

