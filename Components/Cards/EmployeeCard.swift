import SwiftUI

struct EmployeeCard: View {

    let employee: Employee

    var onDepartmentChange: ((EmployeeDepartment) -> Void)?
    
    private var potentialStars: String {

        switch employee.potential {

        case 95...100:
            return "★★★★★"

        case 85..<95:
            return "★★★★☆"

        case 75..<85:
            return "★★★☆☆"

        case 65..<75:
            return "★★☆☆☆"

        default:
            return "★☆☆☆☆"

        }

    }

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
                    
                    Text(employee.specialty)
                        .font(.caption)
                        .foregroundStyle(.purple)

                    Label(
                        employee.department.rawValue,
                        systemImage: employee.department.icon
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    HStack {

                        Label("Potential", systemImage: "star.fill")

                        Spacer()

                        Text(potentialStars)

                    }

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

            if let onDepartmentChange {

                Picker("Department", selection: Binding(
                    get: {
                        employee.department
                    },
                    set: { department in
                        onDepartmentChange(department)
                    }
                )) {

                    ForEach(EmployeeDepartment.allCases) { department in

                        Label(
                            department.rawValue,
                            systemImage: department.icon
                        )
                        .tag(department)

                    }

                }
                .pickerStyle(.menu)

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
        employee: .preview
    )

}
