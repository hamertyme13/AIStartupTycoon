import SwiftUI

struct MainTabView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        TabView {

            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
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

        }
        

        }

    }



#Preview {

    MainTabView()
        .environment(GameManager())

}
