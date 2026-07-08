import SwiftUI
import Observation

struct MainTabView: View {

    @Environment(GameManager.self) private var game

    var body: some View {
        
        @Bindable var game = game

        TabView {

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            NotificationCenterView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }

            CompanyView()
                .tabItem {
                    Label("Company", systemImage: "building.2.fill")
                }
            InnovationView()
                .tabItem {
                    Label("Innovation", systemImage: "lightbulb.fill")
                }

            IndustryView()
                .tabItem {
                    Label("Industry", systemImage: "globe.fill")
                }
            
            InvestorsView()
                .tabItem {
                    Label(
                        "Investors",
                        systemImage: "dollarsign.circle.fill"
                    )
                }
            
            BoardView()
                .tabItem {
                    Label("Board", systemImage: "person.3.fill")
                }
            
    
        }
        .tint(RogueCircuitTheme.electricCyan)
        .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
        .sheet(item: $game.latestReport) { report in

            MonthlyReportView(report: report) {

                game.latestReport = nil

            }

        }
        .sheet(isPresented: $game.showNewGameSetup) {

            NewGameSetupView()
                .interactiveDismissDisabled()

        }
        .sheet(item: $game.currentEvent) { event in

            EventPopup(event: event) { option in

                game.apply(
                    option,
                    from: event
                )

            }

        }
        .interactiveDismissDisabled(game.currentEvent != nil)
        .sheet(item: $game.gameOutcome) { outcome in

            VStack(spacing: 20) {

                Text(outcome.title)
                    .font(.largeTitle)
                    .bold()

                Text(outcome.message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button {

                    game.gameOutcome = nil

                } label: {

                    Label(
                        "Review Company",
                        systemImage: "building.2.fill"
                    )

                }
                .buttonStyle(.borderedProminent)

            }
            .padding(30)

        }

    }

}

struct NewGameSetupView: View {

    @Environment(GameManager.self) private var game

    @State private var selectedScenario: Company.Scenario =
        .bootstrappedFounder

    var body: some View {

        NavigationStack {

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 8) {

                    Text("AI Startup Tycoon")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(RogueCircuitTheme.brandGradient)

                    Text("Choose your opening strategy and build toward market dominance or AGI.")
                        .foregroundStyle(.secondary)

                }

                ForEach(Company.Scenario.allCases) { scenario in

                    Button {

                        selectedScenario = scenario

                    } label: {

                        HStack(spacing: 14) {

                            Image(systemName:
                                selectedScenario == scenario
                                ? "checkmark.circle.fill"
                                : "circle"
                            )
                            .foregroundStyle(
                                selectedScenario == scenario
                                ? RogueCircuitTheme.electricCyan
                                : .secondary
                            )

                            VStack(alignment: .leading, spacing: 4) {

                                Text(scenario.rawValue)
                                    .font(.headline)

                                Text(scenario.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                            }

                            Spacer()

                        }
                        .padding()
                        .rogueCircuitCard(cornerRadius: 12)

                    }
                    .buttonStyle(.plain)

                }

                Spacer()

                Button {

                    game.startNewGame(
                        scenario: selectedScenario
                    )

                } label: {

                    Label(
                        "Start Company",
                        systemImage: "play.fill"
                    )
                    .frame(maxWidth: .infinity)

                }
                .buttonStyle(.borderedProminent)
                .tint(RogueCircuitTheme.signalGreen)

            }
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .padding()
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)

        }

    }

}

#Preview {

    MainTabView()
        .environment(GameManager())

}
