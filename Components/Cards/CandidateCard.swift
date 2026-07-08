import SwiftUI

struct CandidateCard: View {

    @Environment(GameManager.self) private var game

    let candidate: Candidate

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                EmployeeAvatarView(
                    avatar: candidate.avatar,
                    gender: candidate.gender,
                    size: 64
                )

                VStack(alignment: .leading) {

                    Text(candidate.name)
                        .font(.title3)
                        .bold()

                    Text(candidate.careerPath.title(for: 1))
                        .foregroundStyle(.secondary)

                    Text(candidate.gender.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                }

                Spacer()

            }

            Divider()

            HStack {

                Text("Career Path")

                Spacer()

                Text(candidate.careerPath.rawValue)
                    .bold()

            }

            HStack {

                Text("Skill")

                Spacer()

                Text("\(candidate.skill)")

            }

            HStack {

                Text("Potential")

                Spacer()

                Text("\(candidate.potential)")
                    .bold()
                    .foregroundStyle(.yellow)

            }

            HStack {

                Text("Specialty")

                Spacer()

                Text(candidate.specialty)

            }

            HStack {

                Text("Salary")

                Spacer()

                Text("$\(Int(candidate.salary))/mo")

            }

            Button {

                game.hire(candidate)

            } label: {

                Label(
                    "Hire",
                    systemImage: "person.badge.plus.fill"
                )

            }
            .buttonStyle(.borderedProminent)

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }

}

#Preview {

    CandidateCard(
        candidate: Candidate(
            name: "Emily Carter",
            gender: .female,
            role: .researchAssistant,
            careerPath: .research,
            skill: 74,
            salary: 5600,
            potential: 97,
            specialty: "Computer Vision",
            avatar: EmployeeAvatar.random(for: .female)
        )
    )
    .environment(GameManager())

}
//  CandidateCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//
