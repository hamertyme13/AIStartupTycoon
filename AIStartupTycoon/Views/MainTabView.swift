import SwiftUI

struct MainTabView: View {

    var body: some View {

        TabView {

            DashboardView()
                .tabItem {
                    Label("Dashboard",
                          systemImage: "house.fill")
                }

            ProductsView()
                .tabItem {
                    Label("Products",
                          systemImage: "shippingbox.fill")
                }

            EmployeesView()
                .tabItem {
                    Label("Employees",
                          systemImage: "person.3.fill")
                }

            ResearchView()
                .tabItem {
                    Label("Research",
                          systemImage: "brain.head.profile")
                }

            OfficeView()
                .tabItem {
                    Label("Office",
                          systemImage: "building.2.fill")
                }

        }

    }

}

#Preview {
    MainTabView()
}
