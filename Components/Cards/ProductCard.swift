import SwiftUI

struct ProductCard: View {

    let product: Product
    let onBuild: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                VStack(alignment: .leading) {

                    Text(product.name)
                        .font(.title3)
                        .bold()

                    Text(product.description)
                        .foregroundStyle(.secondary)

                }

                Spacer()

                if !product.unlocked {

                    Image(systemName: "lock.fill")
                        .foregroundStyle(.gray)

                }

            }

            Divider()

            Text("⭐ Level \(product.level)")

            Text("👥 Customers: \(product.customers.formatted())")

            Text("📈 Growth: +\(product.dailyGrowth)/sec")

            Text("💵 MRR: $\(Int(product.monthlyRevenue).formatted())")

            Text("🔨 Upgrade Cost: $\(Int(product.buildCost).formatted())")
            
            Button("Build") {

                onBuild()

            }
            .buttonStyle(.borderedProminent)
            .disabled(!product.unlocked)

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

#Preview {

    ProductCard(
        product: Product(
            name: "AI Chatbot",
            description: "Customer Support AI",
            buildCost: 1000,
            revenuePerLevel: 100
        ),
        onBuild: {}
    )

}
//  ProductCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

