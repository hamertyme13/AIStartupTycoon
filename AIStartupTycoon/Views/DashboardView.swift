import SwiftUI
import Combine

struct DashboardView: View {

    @Environment(GameManager.self) private var game

    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common)
        .autoconnect()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 30) {

                    VStack(spacing: 6) {

                        Text(game.company.name)
                            .font(.largeTitle)
                            .bold()

                    }

                    Text("Building the Future of AI")
                        .foregroundStyle(.secondary)

                    StatCard(
                        title: "💰 Cash",
                        value: "$\(Int(game.company.cash).formatted())",
                        color: .green
                    )

                    StatCard(
                        title: "📈 Monthly Revenue",
                        value: "$\(Int(game.company.monthlyRevenue).formatted())",
                        color: .blue
                    )

                    StatCard(
                        title: "🏢 Company Value",
                        value: "$\(Int(game.company.companyValue).formatted())",
                        color: .purple
                    )

                    StatCard(
                        title: "👥 Employees",
                        value: "\(game.company.employees.count)",
                        color: .orange
                    )

                    GroupBox {

                        ProgressBar(progress: game.company.companyHealth)

                    } label: {

                        Label("Company Health",
                              systemImage: "heart.text.square.fill")
                        .font(.headline)
                        .foregroundStyle(.red)

                    }

                    GroupBox {

                        Text(game.company.latestNews)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)

                    } label: {

                        Label("Latest News",
                              systemImage: "newspaper.fill")
                        .font(.headline)

                    }

                }
                .padding()

            }
            .navigationTitle("Dashboard")
            .onReceive(timer) { _ in
                game.tick()
                game.employeeWork()
                game.growProducts()
            }

        }

    }

}

#Preview {

    DashboardView()

}
