import SwiftUI

struct EmployeesView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    // MARK: Talent Market

                    Text("Talent Market")
                        .font(.largeTitle)
                        .bold()

                    Text("Recruit talented people to grow your company.")
                        .foregroundStyle(.secondary)

                    if game.company.talentMarket.isEmpty {

                        ContentUnavailableView(
                            "No Candidates Available",
                            systemImage: "person.crop.circle.badge.questionmark",
                            description: Text("New candidates will appear next month.")
                        )

                    } else {

                        ForEach(game.company.talentMarket) { candidate in

                            CandidateCard(
                                candidate: candidate
                            )

                        }

                    }

                    Divider()
                        .padding(.vertical)

                    // MARK: Current Employees

                    Text("Current Employees")
                        .font(.largeTitle)
                        .bold()

                    ForEach(game.company.employees.indices, id: \.self) { index in

                        EmployeeCard(
                            employee: game.company.employees[index],
                            onDepartmentChange: { department in
                                game.assignEmployee(
                                    at: index,
                                    to: department
                                )
                            }
                        )

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
