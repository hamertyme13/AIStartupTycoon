import SwiftUI

struct LockedProductCard: View {

    let product: Product

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)

                VStack(alignment: .leading) {

                    Text(product.name)
                        .font(.title3)
                        .bold()

                    Text(product.description)
                        .foregroundStyle(.secondary)

                }

            }

            Divider()

            Text("🔒 Locked")

            if let tech = product.requiredTechnology {

                Text("Requires \(tech) research")

                    .foregroundStyle(.orange)

            }

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

#Preview {

    LockedProductCard(
        product: Product(
            name: "AI Agent",
            description: "Autonomous AI",
            buildCost: 50000,
            revenuePerLevel: 3000,
            unlocked: false,
            requiredTechnology: "AI Agents"
        )
    )

}
//  LockedProductCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

