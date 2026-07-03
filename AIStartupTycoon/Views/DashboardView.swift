import SwiftUI
import Combine

struct DashboardView: View {

    @Environment(GameManager.self) private var game

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 30) {

                    // MARK: - Company Header

                    VStack(spacing: 6) {

                        Text(game.company.name)
                            .font(.largeTitle)
                            .bold()

                        Text("Building the Future of AI")
                            .foregroundStyle(.secondary)

                    }

                    // MARK: - Time

                    TimeCard(
                        year: game.company.currentYear,
                        month: game.company.currentMonth
                    )
                    
                    MonthProgressCard(
                        elapsed: game.secondsElapsed,
                        total: game.secondsPerMonth)
                    
                    TimeControls()

                    // MARK: - Stats

                    FinanceCard()
                    
                    GroupBox {

                        VStack(spacing: 16) {

                            HStack {

                                Label("Employees",
                                      systemImage: "person.3.fill")

                                Spacer()

                                Text("\(game.company.employees.count)")
                                    .bold()

                            }

                            HStack {

                                Label("Products",
                                      systemImage: "shippingbox.fill")

                                Spacer()

                                Text("\(game.company.products.filter { $0.unlocked }.count)")
                                    .bold()

                            }

                            HStack {

                                Label("Founder Ownership",
                                      systemImage: "building.columns.fill")

                                Spacer()

                                Text("\(Int(game.company.founderOwnership))%")
                                    .bold()

                            }

                        }

                    } label: {

                        Label("Company",
                              systemImage: "building.2.fill")

                    }

                    // MARK: - Company Health

                    GroupBox {

                        ProgressBar(
                            progress: game.company.companyHealth
                        )

                    } label: {

                        Label(
                            "Company Health",
                            systemImage: "heart.text.square.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(.red)

                    }

                    // MARK: - News

                    GroupBox {

                        Text(game.company.latestNews)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )

                    } label: {

                        Label(
                            "Latest News",
                            systemImage: "newspaper.fill"
                        )
                        .font(.headline)

                    }

                }
                .padding()

            }
            .navigationTitle("Dashboard")

        }
        .onReceive(timer) { _ in

            if game.gameSpeed != .paused {
                game.advanceOneSecond()
                game.secondsElapsed += 1
                if game.secondsElapsed >= game.secondsPerMonth {
                    game.secondsElapsed = 0
                    game.nextMonth()
            }
            }

        }

    }

}

#Preview {

    DashboardView()
        .environment(GameManager())

}
