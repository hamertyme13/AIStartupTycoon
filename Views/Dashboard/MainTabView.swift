import SwiftUI
import Observation

struct MainTabView: View {

    @Environment(GameManager.self) private var game

    var body: some View {
        
        @Bindable var game = game

        TabView {

            TechEmpireGameView()
                .tabItem {
                    Label("HQ", systemImage: "square.grid.3x3.fill")
                }

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

            BetaReadinessView()
                .tabItem {
                    Label("Beta", systemImage: "testtube.2")
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

            VStack(spacing: 22) {

                Image(systemName: outcome.icon)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(
                        outcome.title == "Victory"
                        ? RogueCircuitTheme.signalGreen
                        : Color.orange
                    )
                    .accessibilityHidden(true)

                Text(outcome.title)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(RogueCircuitTheme.brandGradient)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.75)

                Text(outcome.message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(RogueCircuitTheme.mutedText)
                    .fixedSize(horizontal: false, vertical: true)

                Button {

                    game.gameOutcome = nil

                } label: {

                    Label(
                        outcome.primaryActionTitle,
                        systemImage: "building.2.fill"
                    )
                    .frame(maxWidth: .infinity)

                }
                .buttonStyle(.borderedProminent)
                .tint(RogueCircuitTheme.signalGreen)

            }
            .padding(30)
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .preferredColorScheme(.dark)

        }

    }

}

struct BetaReadinessView: View {

    private let privacyURL = URL(
        string: "https://roguecircuit.com/privacy"
    )!

    private let supportURL = URL(
        string: "mailto:support@roguecircuit.com?subject=Tech%20Empire%20Beta%20Feedback"
    )!

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ??
            "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 18) {

                    VStack(alignment: .leading, spacing: 10) {

                        Label(
                            "TestFlight Hub",
                            systemImage: "testtube.2"
                        )
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundStyle(RogueCircuitTheme.brandGradient)

                        Text("Build \(buildNumber) - Version \(appVersion)")
                            .font(.subheadline)
                            .foregroundStyle(RogueCircuitTheme.mutedText)

                        Text("Use this screen for beta support, privacy access, and the current testing focus.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                    }
                    .padding()
                    .rogueCircuitCard(cornerRadius: 18)

                    betaSection(
                        title: "Tester Focus",
                        systemImage: "scope",
                        rows: [
                            BetaInfoRow(
                                title: "First Session",
                                detail: "Start a new game, choose founder details, and confirm the opening scene feels polished."
                            ),
                            BetaInfoRow(
                                title: "Core Loop",
                                detail: "Play through hiring, product upgrades, research, contracts, investors, and monthly reports."
                            ),
                            BetaInfoRow(
                                title: "Balance",
                                detail: "Watch for money exploits, impossible goals, confusing win paths, and unfair competitor pacing."
                            ),
                            BetaInfoRow(
                                title: "Layout",
                                detail: "Report any clipped text, unreadable cards, or controls that run off the screen."
                            )
                        ]
                    )

                    VStack(alignment: .leading, spacing: 14) {

                        Label(
                            "Support & Privacy",
                            systemImage: "lock.shield.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(RogueCircuitTheme.signalGreen)

                        Link(destination: supportURL) {

                            Label(
                                "Email Beta Feedback",
                                systemImage: "envelope.fill"
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                        .buttonStyle(.borderedProminent)
                        .tint(RogueCircuitTheme.signalGreen)

                        Link(destination: privacyURL) {

                            Label(
                                "Privacy Policy",
                                systemImage: "hand.raised.fill"
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                        .buttonStyle(.bordered)
                        .tint(RogueCircuitTheme.electricCyan)

                        Text("Current beta saves gameplay locally on device. If cloud saves, analytics, Game Center, or crash tooling are added, privacy disclosures must be updated before wider testing.")
                            .font(.caption)
                            .foregroundStyle(RogueCircuitTheme.mutedText)
                            .fixedSize(horizontal: false, vertical: true)

                    }
                    .padding()
                    .rogueCircuitCard(cornerRadius: 18)

                    betaSection(
                        title: "Known Beta Checklist",
                        systemImage: "checklist",
                        rows: [
                            BetaInfoRow(
                                title: "Internal TestFlight",
                                detail: "Upload a signed Release archive and invite internal testers first."
                            ),
                            BetaInfoRow(
                                title: "External Beta",
                                detail: "Add beta review notes, screenshots, privacy answers, support URL, and tester instructions in App Store Connect."
                            ),
                            BetaInfoRow(
                                title: "Before Public Launch",
                                detail: "Finish App Store screenshots, age rating, monetization decision, Game Center configuration, and final balance pass."
                            )
                        ]
                    )

                }
                .padding(.horizontal, 14)
                .padding(.vertical, 16)

            }
            .scrollContentBackground(.hidden)
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .navigationTitle("Beta")
            .navigationBarTitleDisplayMode(.inline)

        }
        .preferredColorScheme(.dark)

    }

    private func betaSection(
        title: String,
        systemImage: String,
        rows: [BetaInfoRow]
    ) -> some View {

        VStack(alignment: .leading, spacing: 14) {

            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(RogueCircuitTheme.signalGreen)

            ForEach(rows) { row in

                VStack(alignment: .leading, spacing: 4) {

                    Text(row.title)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Text(row.detail)
                        .font(.caption)
                        .foregroundStyle(RogueCircuitTheme.mutedText)
                        .fixedSize(horizontal: false, vertical: true)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)

            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 18)

    }

}

private struct BetaInfoRow: Identifiable {

    let id = UUID()
    let title: String
    let detail: String

}

struct NewGameSetupView: View {

    @Environment(GameManager.self) private var game

    @State private var selectedScenario: Company.Scenario =
        .bootstrappedFounder

    @State private var playerName = ""

    @State private var companyName = ""

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Tech Empire")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(RogueCircuitTheme.brandGradient)

                        Text("Name your founder, pick a company identity, and choose your opening strategy.")
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                    }

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Founder")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(RogueCircuitTheme.signalGreen)
                            .textCase(.uppercase)

                        TextField("Your name", text: $playerName)
                            .textInputAutocapitalization(.words)
                            .textFieldStyle(.roundedBorder)

                        Text("Company")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(RogueCircuitTheme.signalGreen)
                            .textCase(.uppercase)

                        TextField("Tech Empire Labs", text: $companyName)
                            .textInputAutocapitalization(.words)
                            .textFieldStyle(.roundedBorder)

                    }
                    .padding()
                    .rogueCircuitCard(cornerRadius: 16)

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
                                        .fixedSize(horizontal: false, vertical: true)

                                }

                                Spacer()

                            }
                            .padding()
                            .rogueCircuitCard(cornerRadius: 12)

                        }
                        .buttonStyle(.plain)

                    }

                    Button {

                        game.startNewGame(
                            scenario: selectedScenario,
                            playerName: playerName,
                            companyName: companyName
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
                    .padding(.top, 4)

                }
                .padding()

            }
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)

        }

    }

}

#Preview {

    MainTabView()
        .environment(GameManager())

}
