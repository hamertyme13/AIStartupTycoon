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
        .background(
            LinearGradient(
                colors: [
                    color.opacity(0.18),
                    RogueCircuitTheme.panelRaised.opacity(0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.24), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))

    }

}
//  StatCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/1/26.
//
