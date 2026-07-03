import SwiftUI

struct OfficeView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    GroupBox("Founder Ownership") {

                        Text("\(Int(game.company.founderOwnership))%")
                            .font(.largeTitle)
                            .bold()

                    }

                    ForEach(game.company.investors.indices, id: \.self) { index in

                        InvestorCard(investor: game.company.investors[index]) {

                            withAnimation {

                                game.acceptInvestment(index: index)

                            }

                        }

                    }

                }
                .padding()

            }
            .navigationTitle("Investors")

        }

    }

}

#Preview {

    OfficeView()
        .environment(GameManager())

}
