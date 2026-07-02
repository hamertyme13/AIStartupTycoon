import SwiftUI

struct EmployeesView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    Button {

                        withAnimation(.spring()) {

                            game.hireEngineer()

                        }

                    } label: {

                        Label("Hire Engineer ($500)", systemImage: "person.badge.plus")

                            .frame(maxWidth: .infinity)

                    }
                    .buttonStyle(.borderedProminent)

                    ForEach(game.company.employees) { employee in

                        EmployeeCard(employee: employee)

                    }

                }
                .padding()

            }
            .navigationTitle("Employees")

        }

    }

}

#Preview {

    EmployeesView()
        .environment(GameManager())

}
