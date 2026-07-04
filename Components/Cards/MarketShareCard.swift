import SwiftUI

struct MarketShareCard: View {

    let name: String
    let share: Double
    let color: Color

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack {

                Text(name)

                Spacer()

                Text("\(Int(share))%")

            }

            ProgressView(value: share, total: 100)
                .tint(color)

        }

    }

}
//  MarketShareCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

