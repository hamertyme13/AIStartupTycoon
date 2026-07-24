import SwiftUI

struct ResearchView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                LazyVStack(spacing: 20) {

                    ForEach(game.company.technologies.indices, id: \.self) { index in
                        
                        StatCard(
                            title: "🧠 Research / Second",
                            value: String(
                                format: "%.1f",
                                game.company.employees.reduce(0) {
                                    $0 + $1.researchOutput
                                }
                            ),
                            color: .purple
                        )
                        
                        StatCard(
                            title: "🔬 Total Research",
                            value: "\(Int(game.company.researchPoints)) RP",
                            color: .blue
                        )

                        StatCard(
                            title: "💸 Research Cost",
                            value: "$\(Int(game.company.researchExpense))/mo",
                            color: .red
                        )

                        ResearchCard(
                            technology: game.company.technologies[index],
                            index: index
                        )

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
