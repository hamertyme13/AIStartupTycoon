import SwiftUI

struct ReportRow: View {

    let title: String
    let amount: Double
    let positive: Bool

    var body: some View {

        HStack {

            Text(title)

            Spacer()

            Text("\(positive ? "+" : "-")$\(Int(abs(amount)).formatted())")
                .foregroundStyle(positive ? .green : .red)
                .bold()

        }

    }

}
//  ReportRow.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/2/26.
//

