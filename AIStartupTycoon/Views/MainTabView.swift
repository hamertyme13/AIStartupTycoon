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

            ProductsView()
                .tabItem {
                    Label("Products", systemImage: "shippingbox.fill")
                }

            EmployeesView()
                .tabItem {
                    Label("Employees", systemImage: "person.3.fill")
                }

            ResearchView()
                .tabItem {
                    Label("Research", systemImage: "brain.head.profile")
                }

            OfficeView()
                .tabItem {
                    Label("Company", systemImage: "building.2.fill")
                }
            
            MarketView()
                .tabItem {
                    Label(
                        "Market",
                        systemImage: "chart.bar.xaxis"
                    )
                }
            
            MarketingView()
                .tabItem {
                    Label("Marketing",
                          systemImage: "megaphone.fill")
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
