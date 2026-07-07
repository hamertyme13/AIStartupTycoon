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
        .sheet(item: $game.latestReport) { report in

            MonthlyReportView(report: report) {

                game.latestReport = nil

            }

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

#Preview {

    MainTabView()
        .environment(GameManager())

}
