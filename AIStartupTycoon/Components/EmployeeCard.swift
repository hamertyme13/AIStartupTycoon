import SwiftUI

struct EmployeeCard: View {

    let employee: Employee

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text(employee.name)
                        .font(.title3)
                        .bold()

                    Text(employee.role.rawValue)
                        .foregroundStyle(.secondary)

                    // NEW
                    Text("Level \(employee.level)")
                        .font(.caption)
                        .foregroundStyle(.blue)

                }

                Spacer()

                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)

            }

            Divider()

            // MARK: Experience

            ProgressView(
                value: employee.experience,
                total: employee.experienceNeeded
            )

            Text(
                "\(Int(employee.experience)) / \(Int(employee.experienceNeeded)) XP"
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Divider()

            HStack {

                Label("Skill", systemImage: "brain.head.profile")

                Spacer()

                Text("\(employee.skill)")

            }

            HStack {

                Label("Salary", systemImage: "dollarsign.circle")

                Spacer()

                Text("$\(Int(employee.salary))/mo")

            }

            HStack {

                Label("Productivity", systemImage: "bolt.fill")

                Spacer()

                Text("\(Int(employee.productivity * 100))%")

            }

            // NEW
            HStack {

                Label("Research", systemImage: "flask.fill")

                Spacer()

                Text(String(format: "%.1f RP/s", employee.researchOutput))

            }

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

#Preview {

    EmployeeCard(
        employee: Employee(
            name: "Emily",
            role: .seniorEngineer,
            salary: 9000,
            skill: 88
        )
    )

}
