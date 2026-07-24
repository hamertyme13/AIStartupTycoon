import SpriteKit
import SwiftUI

struct TechEmpireGameView: View {

    @Environment(GameManager.self) private var game

    @State private var scene = OfficeScene(size: CGSize(width: 900, height: 620))

    @State private var selectedEmployeeID: UUID?

    private var employeeSnapshots: [OfficeEmployeeSnapshot] {

        game.company.employees.map {
            OfficeEmployeeSnapshot(
                id: $0.id,
                name: $0.name,
                title: $0.careerTitle,
                department: $0.department,
                morale: $0.morale,
                burnout: $0.burnout,
                loyalty: $0.loyalty,
                skill: $0.skill,
                level: $0.level
            )
        }

    }

    private var selectedEmployeeIndex: Int? {

        guard let selectedEmployeeID else {
            return nil
        }

        return game.company.employees.firstIndex {
            $0.id == selectedEmployeeID
        }

    }

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 16) {

                    header

                    SpriteView(
                        scene: scene,
                        options: [
                            .allowsTransparency
                        ]
                    )
                    .frame(height: 430)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(
                                RogueCircuitTheme.signalGreen.opacity(0.45),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: RogueCircuitTheme.electricCyan.opacity(0.18),
                        radius: 20,
                        y: 10
                    )
                    .accessibilityLabel("Animated headquarters floor")

                    metricsGrid

                    legend

                }
                .padding(.horizontal, 14)
                .padding(.vertical, 16)

            }
            .scrollContentBackground(.hidden)
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .navigationTitle("HQ")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: selectedEmployeeIsPresented) {

                if let index = game.company.employees.firstIndex(where: {
                    $0.id == selectedEmployeeID
                }) {

                    HQEmployeeDetailSheet(
                        employee: game.company.employees[index],
                        onAssign: { department in
                            game.assignEmployee(
                                at: index,
                                to: department
                            )
                            refreshScene()
                        },
                        onFire: {
                            game.fireEmployee(at: index)
                            selectedEmployeeID = nil
                            refreshScene()
                        }
                    )

                }

            }
            .onAppear {

                scene.onSelectEmployee = { id in

                    selectedEmployeeID = id

                }

                refreshScene()

            }
            .onChange(of: sceneSignature) { _, _ in

                refreshScene()

            }

        }
        .preferredColorScheme(.dark)

    }

    private var selectedEmployeeIsPresented: Binding<Bool> {

        Binding(
            get: {
                selectedEmployeeID != nil
            },
            set: {
                if !$0 {
                    selectedEmployeeID = nil
                }
            }
        )

    }

    private var sceneSignature: String {

        [
            game.company.name,
            "\(Int(game.company.cash))",
            "\(game.company.customerSatisfaction)",
            "\(Int(game.company.runwayMonths))",
            employeeSnapshots.map {
                "\($0.id.uuidString):\($0.department.rawValue):\($0.morale):\($0.burnout):\($0.loyalty):\($0.level)"
            }
            .joined(separator: "|")
        ]
        .joined(separator: "#")

    }

    private var header: some View {

        VStack(alignment: .leading, spacing: 8) {

            Label("Living Headquarters", systemImage: "building.2.fill")
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(RogueCircuitTheme.brandGradient)

            Text("Tap employees on the floor to inspect morale, burnout, loyalty, and department focus.")
                .font(.subheadline)
                .foregroundStyle(RogueCircuitTheme.mutedText)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 18)

    }

    private var metricsGrid: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ],
            spacing: 10
        ) {

            HQMetricTile(
                title: "Team",
                value: "\(game.company.employees.count)",
                systemImage: "person.3.fill"
            )

            HQMetricTile(
                title: "Avg Morale",
                value: "\(average(\.morale))%",
                systemImage: "heart.fill"
            )

            HQMetricTile(
                title: "Avg Burnout",
                value: "\(average(\.burnout))%",
                systemImage: "flame.fill"
            )

            HQMetricTile(
                title: "Avg Loyalty",
                value: "\(average(\.loyalty))%",
                systemImage: "shield.fill"
            )

        }

    }

    private var legend: some View {

        VStack(alignment: .leading, spacing: 12) {

            Label("Floor Signals", systemImage: "waveform.path.ecg")
                .font(.headline)
                .foregroundStyle(RogueCircuitTheme.signalGreen)

            Text("FLOW means morale is high. BURNOUT means the employee needs relief. POACH means loyalty is low and rivals may make a move.")
                .font(.caption)
                .foregroundStyle(RogueCircuitTheme.mutedText)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 18)

    }

    private func average(
        _ keyPath: KeyPath<Employee, Int>
    ) -> Int {

        guard !game.company.employees.isEmpty else {
            return 0
        }

        let total = game.company.employees.reduce(0) {
            $0 + $1[keyPath: keyPath]
        }

        return total / game.company.employees.count

    }

    private func refreshScene() {

        scene.updateOffice(
            employees: employeeSnapshots,
            companyName: game.company.name,
            cash: game.company.cash,
            customerSatisfaction: game.company.customerSatisfaction,
            runwayMonths: Int(game.company.runwayMonths)
        )

    }

}

private struct HQMetricTile: View {

    let title: String
    let value: String
    let systemImage: String

    var body: some View {

        HStack(spacing: 10) {

            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(RogueCircuitTheme.signalGreen)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 2) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(RogueCircuitTheme.mutedText)

                Text(value)
                    .font(.headline)
                    .fontWeight(.black)

            }

            Spacer(minLength: 0)

        }
        .padding()
        .frame(minHeight: 72)
        .rogueCircuitCard(cornerRadius: 14)

    }

}

private struct HQEmployeeDetailSheet: View {

    let employee: Employee
    let onAssign: (EmployeeDepartment) -> Void
    let onFire: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 18) {

                    HStack(alignment: .center, spacing: 14) {

                        EmployeeAvatarView(
                            avatar: employee.avatar,
                            gender: employee.gender,
                            size: 72
                        )

                        VStack(alignment: .leading, spacing: 4) {

                            Text(employee.name)
                                .font(.title3)
                                .fontWeight(.black)

                            Text(employee.careerTitle)
                                .font(.subheadline)
                                .foregroundStyle(RogueCircuitTheme.mutedText)

                            Label(
                                employee.department.rawValue,
                                systemImage: employee.department.icon
                            )
                            .font(.caption)
                            .foregroundStyle(RogueCircuitTheme.signalGreen)

                        }

                    }

                    Divider()

                    VStack(spacing: 12) {

                        employeeStatRow(
                            "Morale",
                            value: employee.morale,
                            systemImage: "heart.fill"
                        )

                        employeeStatRow(
                            "Burnout",
                            value: employee.burnout,
                            systemImage: "flame.fill"
                        )

                        employeeStatRow(
                            "Loyalty",
                            value: employee.loyalty,
                            systemImage: "shield.fill"
                        )

                        employeeStatRow(
                            "Skill",
                            value: employee.skill,
                            systemImage: "brain.head.profile"
                        )

                    }

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Assign Focus")
                            .font(.headline)

                        ForEach(EmployeeDepartment.allCases) { department in

                            Button {

                                onAssign(department)
                                dismiss()

                            } label: {

                                Label(
                                    department.rawValue,
                                    systemImage: department.icon
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)

                            }
                            .buttonStyle(.bordered)
                            .tint(
                                department == employee.department
                                ? RogueCircuitTheme.signalGreen
                                : RogueCircuitTheme.electricCyan
                            )

                        }

                    }

                    if employee.name != "You" {

                        Button(role: .destructive) {

                            onFire()
                            dismiss()

                        } label: {

                            Label("Fire Employee", systemImage: "person.crop.circle.badge.xmark")
                                .frame(maxWidth: .infinity)

                        }
                        .buttonStyle(.borderedProminent)

                    }

                }
                .padding()

            }
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .navigationTitle("Employee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Done") {
                        dismiss()
                    }

                }

            }

        }
        .preferredColorScheme(.dark)

    }

    private func employeeStatRow(
        _ title: String,
        value: Int,
        systemImage: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack {

                Label(title, systemImage: systemImage)

                Spacer()

                Text("\(value)%")
                    .fontWeight(.bold)

            }
            .font(.subheadline)

            ProgressView(value: Double(value), total: 100)
                .tint(tint(for: title, value: value))

        }

    }

    private func tint(for title: String, value: Int) -> Color {

        if title == "Burnout" {
            return value >= 70 ? .red : RogueCircuitTheme.electricCyan
        }

        if value >= 80 {
            return RogueCircuitTheme.signalGreen
        }

        if value < 50 {
            return .orange
        }

        return RogueCircuitTheme.electricCyan

    }

}

#Preview {

    TechEmpireGameView()
        .environment(GameManager())

}
