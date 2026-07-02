import SwiftUI
import Combine

struct DashboardView: View {

    @State var game = GameManager()

    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common)
        .autoconnect()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    Text(game.company.name)
                        .font(.largeTitle)
                        .bold()

                    Text("Building the Future of AI")
                        .foregroundStyle(.secondary)

                    StatCard(
                        title: "💰 Cash",
                        value: "$\(Int(game.company.cash))",
                        color: .green
                    )

                    StatCard(
                        title: "📈 Monthly Revenue",
                        value: "$\(Int(game.company.monthlyRevenue))",
                        color: .blue
                    )

                    StatCard(
                        title: "🏢 Company Value",
                        value: "$\(Int(game.company.companyValue))",
                        color: .purple
                    )

                    StatCard(
                        title: "👥 Employees",
                        value: "\(game.company.employeeCount)",
                        color: .orange
                    )

                    GroupBox("Company News") {

                        Text(game.company.latestNews)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)

                    }

                }
                .padding()

            }
            .navigationTitle("Dashboard")
            .onReceive(timer) { _ in
                game.tick()
            }

        }

    }

}

#Preview {

    DashboardView()

}
