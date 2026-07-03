import SwiftUI

struct FinanceRow: View {

    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {

        HStack {

            Label(title, systemImage: icon)
                .foregroundStyle(color)

            Spacer()

            Text(value)
                .bold()

        }

    }

}
//  FinanceRow.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

