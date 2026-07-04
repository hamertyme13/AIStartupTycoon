import SwiftUI

struct OfficeView: View {

    @Environment(GameManager.self) private var game

    var currentOffice: Office {
        game.company.currentOffice
    }

    var nextOffice: Office? {

        guard game.company.officeLevel <
                game.company.offices.count - 1 else {

            return nil

        }

        return game.company.offices[
            game.company.officeLevel + 1
        ]

    }
    
    var upgradeProgress: Double {

        guard let nextOffice else {

            return 1.0

        }

        return min(
            game.company.cash / nextOffice.cost,
            1.0
        )

    }

    var progressPercent: Int {

        Int(upgradeProgress * 100)

    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    // MARK: Current Office

                    GroupBox("Current Headquarters") {

                        VStack(spacing: 12) {

                            Text(currentOffice.icon)
                                .font(.system(size: 60))

                            Text(currentOffice.name)
                                .font(.title2)
                                .bold()

                            Divider()

                            HStack {

                                Text("Monthly Rent")

                                Spacer()

                                Text("$\(Int(currentOffice.monthlyRent).formatted())")

                            }

                            HStack {

                                Text("Productivity Bonus")

                                Spacer()

                                Text("+\(Int(currentOffice.productivityBonus * 100))%")

                            }

                            HStack {

                                Text("Research Bonus")

                                Spacer()

                                Text("+\(Int(currentOffice.researchBonus * 100))%")

                            }

                            HStack {

                                Text("Reputation Bonus")

                                Spacer()

                                Text("+\(currentOffice.reputationBonus)")

                            }

                        }

                    }

                    // MARK: Upgrade

                    if let nextOffice {

                        GroupBox("Next Upgrade") {

                            VStack(spacing: 16) {

                                Text(nextOffice.icon)
                                    .font(.system(size: 50))

                                Text(nextOffice.name)
                                    .font(.headline)

                                Text("Upgrade Cost")

                                Text("$\(Int(nextOffice.cost).formatted())")
                                    .font(.title2)
                                    .bold()
                                
                                Divider()

                                Text("Progress to Upgrade")
                                    .font(.headline)

                                ProgressView(value: upgradeProgress)
                                    .tint(.green)

                                Text(
                                    "$\(Int(game.company.cash).formatted()) / $\(Int(nextOffice.cost).formatted())"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)

                                Text("\(progressPercent)% Complete")
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle(.blue)

                                Button {

                                    withAnimation {

                                        game.upgradeOffice()

                                    }

                                } label: {

                                    if game.company.cash >= nextOffice.cost {

                                        Label(
                                            "Upgrade Headquarters",
                                            systemImage: "building.2.fill"
                                        )

                                    } else {

                                        Label(
                                            "Need $\(Int(nextOffice.cost - game.company.cash).formatted()) More",
                                            systemImage: "lock.fill"
                                        )

                                    }

                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(game.company.cash < nextOffice.cost)
                            }

                        }

                    } else {

                        GroupBox {

                            Label(
                                "Maximum Headquarters Reached",
                                systemImage: "checkmark.seal.fill"
                            )
                            .foregroundStyle(.green)

                        }

                    }

                }
                .padding()

            }
            .navigationTitle("Headquarters")

        }
        
        
    }

}

#Preview {

    OfficeView()
        .environment(GameManager())

}
