import SwiftUI

struct CompanyView: View {
    
    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 18) {
                    
                    ExecutiveSummaryCard()
                    
                    DepartmentCard(

                        title: "Employees",

                        subtitle: "Hire, promote and manage talent.",

                        icon: "person.3.fill",

                        stat1Title: "Employees",

                        stat1Value: "\(game.company.employees.count)",

                        stat2Title: "Payroll",

                        stat2Value: "$\(Int(game.company.monthlyExpenses).formatted())"

                    ) {

                        EmployeesView()

                    }

                   
                    DepartmentCard(

                        title: "Products",

                        subtitle: "Launch and improve AI products.",

                        icon: "shippingbox.fill",

                        stat1Title: "Released",

                        stat1Value: "\(game.company.products.filter { $0.unlocked }.count)",

                        stat2Title: "Revenue",

                        stat2Value: "$\(Int(game.company.monthlyRevenue).formatted())"

                    ) {

                        ProductsView()

                    }

                    DepartmentCard(

                        title: "Headquarters",

                        subtitle: "Upgrade your offices.",

                        icon: "building.2.fill",

                        stat1Title: "Office",

                        stat1Value: game.company.currentOffice.name,

                        stat2Title: "Rent",

                        stat2Value: "$\(Int(game.company.currentOffice.monthlyRent).formatted())"

                    ) {

                        OfficeView()

                    }
                    
                    DepartmentCard(

                        title: "Investors",

                        subtitle: "Raise venture capital.",

                        icon: "dollarsign.circle.fill",

                        stat1Title: "Board",

                        stat1Value: "\(game.company.activeInvestors.count)",

                        stat2Title: "Ownership",

                        stat2Value: "\(Int(game.company.founderOwnership))%"

                    ) {

                        InvestorsView()

                    }

                    DepartmentCard(

                        title: "Board",

                        subtitle: "Review ownership and directors.",

                        icon: "person.2.square.stack.fill",

                        stat1Title: "Members",

                        stat1Value: "\(game.company.activeInvestors.count + 1)",

                        stat2Title: "Founder",

                        stat2Value: "\(Int(game.company.founderOwnership))%"

                    ) {

                        BoardView()

                    }
                }
                .padding()

            }

            }
            .navigationTitle("Company")

        }

    }



#Preview {

    CompanyView()

}
//  CompanyView.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/4/26.
//

