import SwiftUI

struct ProgressBar: View {

    let progress: Double

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            ProgressView(value: progress)

            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)

        }

    }

}

#Preview {

    ProgressBar(progress: 0.72)

}
//  ProgressBar.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

