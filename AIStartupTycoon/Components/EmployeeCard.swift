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

                }

                Spacer()

                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)

            }

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
//  EmployeeCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

