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

    }

}

#Preview {

    MainTabView()
        .environment(GameManager())

}
