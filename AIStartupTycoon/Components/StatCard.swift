import SwiftUI

struct StatCard: View {

    let title: String
    let value: String
    let color: Color

    var body: some View {

        HStack {

            VStack(alignment: .leading) {

                Text(title)
                    .font(.headline)

                Text(value)
                    .font(.title2)
                    .bold()

            }

            Spacer()

        }
        .padding()
        .background(color.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))

    }

}
//  StatCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/1/26.
//

