import SwiftUI

struct MonthlyReportView: View {

    let report: MonthlyReport

    let dismiss: () -> Void

    var body: some View {

        NavigationStack {

            VStack(spacing: 24) {

                Text("📅 Monthly Report")
                    .font(.largeTitle)
                    .bold()

                Text("Year \(report.year) • Month \(report.month)")
                    .foregroundStyle(.secondary)

                Divider()

                ReportRow(
                    title: "Revenue",
                    amount: report.revenue,
                    positive: true
                )

                ReportRow(
                    title: "Payroll",
                    amount: report.payroll,
                    positive: false
                )

                ReportRow(
                    title: "Office Rent",
                    amount: report.officeRent,
                    positive: false
                )

                ReportRow(
                    title: "Cloud Servers",
                    amount: report.serverCost,
                    positive: false
                )

                ReportRow(
                    title: "Research",
                    amount: report.researchCost,
                    positive: false
                )

                Divider()

                ReportRow(
                    title: "Net Profit",
                    amount: report.profit,
                    positive: report.profit >= 0
                )

                Divider()

                Text("Cash Remaining")
                    .font(.headline)

                Text("$\(Int(report.endingCash).formatted())")
                    .font(.largeTitle)
                    .bold()

                Spacer()

                Button("Continue") {

                    dismiss()

                }
                .buttonStyle(.borderedProminent)

            }
            .padding()

        }

    }

}
//  MonthlyReportView.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

