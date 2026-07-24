import SwiftUI

struct ProductsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 20) {

                    ForEach(game.company.products.indices, id: \.self) { index in

                        let product = game.company.products[index]

                        if product.unlocked {

                            ProductCard(
                                product: product
                            ) {

                                withAnimation(.spring()) {

                                    game.buildProduct(index: index)

                                }

                            } onStrategyChange: { strategy in

                                game.setProductStrategy(
                                    index: index,
                                    strategy: strategy
                                )

                            }

                        } else {

                            LockedProductCard(
                                product: product
                            )

                        }

                    }

                

                }
                .padding()

            }
            .navigationTitle("Products")

        }

    }

}

#Preview {

    ProductsView()

}
