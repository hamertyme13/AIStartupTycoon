import SwiftUI

struct EmployeeCard: View {

    let employee: Employee

    var onDepartmentChange: ((EmployeeDepartment) -> Void)?

    var onFire: (() -> Void)?
    
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

                    Text(employee.careerTitle)
                        .foregroundStyle(.secondary)

                    Text("Level \(employee.level) · \(employee.careerPath.rawValue)")
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

                EmployeeAvatarView(
                    avatar: employee.avatar,
                    gender: employee.gender,
                    size: 72
                )

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

            HStack {

                Label("Morale", systemImage: "face.smiling")

                Spacer()

                Text("\(employee.morale)%")
                    .foregroundStyle(employee.morale >= 60 ? .green : .orange)

            }

            HStack {

                Label("Burnout", systemImage: "flame.fill")

                Spacer()

                Text("\(employee.burnout)%")
                    .foregroundStyle(employee.burnout < 65 ? Color.secondary : Color.red)

            }

            HStack {

                Label("Loyalty", systemImage: "shield.checkered")

                Spacer()

                Text("\(employee.loyalty)%")
                    .foregroundStyle(employee.loyalty >= 55 ? .green : .orange)

            }

            // NEW
            HStack {

                Label("Research", systemImage: "flask.fill")

                Spacer()

                Text(String(format: "%.1f RP/s", employee.researchOutput))

            }

            if let onFire {

                Button(role: .destructive) {

                    onFire()

                } label: {

                    Label("Fire Employee", systemImage: "person.crop.circle.badge.xmark")
                        .frame(maxWidth: .infinity)

                }
                .buttonStyle(.bordered)
                .disabled(employee.name == "You")

            }

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

struct EmployeeAvatarView: View {

    let avatar: EmployeeAvatar
    let gender: EmployeeGender
    let size: CGFloat

    private var skinColor: Color {

        [
            Color(red: 0.96, green: 0.74, blue: 0.55),
            Color(red: 0.86, green: 0.58, blue: 0.38),
            Color(red: 0.70, green: 0.43, blue: 0.27),
            Color(red: 0.52, green: 0.31, blue: 0.20),
            Color(red: 0.36, green: 0.22, blue: 0.15),
            Color(red: 0.99, green: 0.82, blue: 0.66)
        ][avatar.skinTone % 6]

    }

    private var hairColor: Color {

        [
            .black,
            Color(red: 0.20, green: 0.11, blue: 0.05),
            Color(red: 0.46, green: 0.26, blue: 0.10),
            Color(red: 0.88, green: 0.63, blue: 0.28),
            Color(red: 0.62, green: 0.08, blue: 0.08),
            Color(red: 0.14, green: 0.16, blue: 0.20),
            Color(red: 0.72, green: 0.74, blue: 0.78)
        ][avatar.hairColor % 7]

    }

    private var backgroundColors: [Color] {

        let palettes: [[Color]] = [
            [.teal, .blue],
            [.indigo, .cyan],
            [.green, .mint],
            [.pink, .orange],
            [.purple, .red],
            [.yellow, .orange],
            [.gray, .blue],
            [.brown, .orange]
        ]

        return palettes[avatar.backgroundStyle % palettes.count]

    }

    private var shirtColor: Color {

        [
            .blue,
            .green,
            .purple,
            .orange,
            .red,
            .teal,
            .indigo,
            .gray
        ][avatar.shirtColor % 8]

    }

    var body: some View {

        ZStack {

            Circle()
                .fill(
                    LinearGradient(
                        colors: backgroundColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 0) {

                Spacer()

                ZStack(alignment: .top) {

                    hairView
                        .frame(
                            width: size * 0.58,
                            height: size * 0.44
                        )
                        .offset(y: -size * 0.02)

                    Circle()
                        .fill(skinColor)
                        .frame(
                            width: size * 0.46,
                            height: size * 0.46
                        )
                        .offset(y: size * 0.10)

                    faceDetails
                        .frame(
                            width: size * 0.32,
                            height: size * 0.18
                        )
                        .offset(y: size * 0.22)

                    if avatar.accessory % 3 == 0 {

                        glasses
                            .stroke(.black.opacity(0.65), lineWidth: 1.5)
                            .frame(
                                width: size * 0.30,
                                height: size * 0.10
                            )
                            .offset(y: size * 0.22)

                    }

                }
                .frame(height: size * 0.55)

                Capsule()
                    .fill(shirtColor)
                    .frame(
                        width: size * 0.56,
                        height: size * 0.28
                    )
                    .offset(y: size * 0.05)

            }
            .clipShape(Circle())

        }
        .frame(width: size, height: size)
        .overlay(
            Circle()
                .stroke(.white.opacity(0.8), lineWidth: 2)
        )
        .shadow(radius: 2, y: 1)

    }

    @ViewBuilder
    private var hairView: some View {

        switch avatar.hairStyle % 7 {

        case 0:
            Capsule()
                .fill(hairColor)

        case 1:
            RoundedRectangle(cornerRadius: size * 0.12)
                .fill(hairColor)

        case 2:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.20,
                bottomLeadingRadius: size * 0.06,
                bottomTrailingRadius: size * 0.18,
                topTrailingRadius: size * 0.20
            )
            .fill(hairColor)

        case 3:
            Ellipse()
                .fill(hairColor)

        case 4:
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.08,
                bottomLeadingRadius: size * 0.18,
                bottomTrailingRadius: size * 0.06,
                topTrailingRadius: size * 0.22
            )
            .fill(hairColor)

        case 5:
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(hairColor)

        default:
            Capsule()
                .fill(hairColor)

        }

    }

    private var faceDetails: some View {

        VStack(spacing: size * 0.04) {

            HStack(spacing: size * 0.10) {

                Circle()
                    .fill(.black.opacity(0.75))
                    .frame(width: size * 0.035, height: size * 0.035)

                Circle()
                    .fill(.black.opacity(0.75))
                    .frame(width: size * 0.035, height: size * 0.035)

            }

            Capsule()
                .fill(.black.opacity(0.35))
                .frame(width: size * 0.12, height: size * 0.018)

        }

    }

    private var glasses: Path {

        Path { path in

            path.addEllipse(in: CGRect(x: 0, y: 0, width: size * 0.10, height: size * 0.08))
            path.addEllipse(in: CGRect(x: size * 0.20, y: 0, width: size * 0.10, height: size * 0.08))
            path.move(to: CGPoint(x: size * 0.10, y: size * 0.04))
            path.addLine(to: CGPoint(x: size * 0.20, y: size * 0.04))

        }

    }

}

#Preview {

    EmployeeCard(
        employee: .preview
    )

}
