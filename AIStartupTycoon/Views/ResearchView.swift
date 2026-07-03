import SwiftUI

struct ResearchView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    ForEach(game.company.technologies.indices, id: \.self) { index in

                        TechnologyCard(
                            technology: game.company.technologies[index]
                        ) {

                            ResearchManager.research(
                                company: &game.company,
                                index: index
                            )

                        }

                    }

                }
                .padding()

            }
            .navigationTitle("Research")

        }

    }

}

#Preview {

    ResearchView()
        .environment(GameManager())

}
