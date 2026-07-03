import SwiftUI
import Combine

struct DashboardView: View {

    @Environment(GameManager.self) private var game

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    private let columns = [

        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)

    ]

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    // MARK: - Company Header

                    VStack(spacing: 8) {

                        Text(game.company.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(game.company.companyStatus)
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.thinMaterial)
                            .clipShape(Capsule())

                        Text(
                            "Year \(game.company.currentYear) • Month \(game.company.currentMonth)"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        Text("Building the Future of AI")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                    }

                    // MARK: - Time

                    TimeCard(
                        year: game.company.currentYear,
                        month: game.company.currentMonth
                    )

                    MonthProgressCard(
                        elapsed: game.secondsElapsed,
                        total: game.secondsPerMonth
                    )

                    TimeControls()

                    // MARK: - Dashboard Cards

                    LazyVGrid(
                        columns: columns,
                        spacing: 16
                    ) {

                        FinanceCard()
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 220)

                        CompanyCard()
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 220)

                        HeadquartersCard()
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 220)

                        ResearchStatusCard()
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 220)

                    }

                    // MARK: - Company Health

                    CompanyHealthCard()

                    // MARK: - Latest News

                    NewsCard()

                }
                .padding()

            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)

        }
        .onReceive(timer) { _ in

            guard game.gameSpeed != .paused else {

                return

            }

            game.advanceOneSecond()

            game.secondsElapsed += 1

            if game.secondsElapsed >= game.secondsPerMonth {

                game.secondsElapsed = 0

                game.nextMonth()

            }

        }

    }

}

#Preview {

    DashboardView()
        .environment(GameManager())

}
