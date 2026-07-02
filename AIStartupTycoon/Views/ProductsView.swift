import SwiftUI

struct ProductsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 20) {

                    ForEach(game.company.products.indices, id: \.self) { index in

                        ProductCard(
                            product: game.company.products[index]
                        ) {

                            withAnimation(.spring()) {

                                game.buildProduct(index: index)

                            }

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
