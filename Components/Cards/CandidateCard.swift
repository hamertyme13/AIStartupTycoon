import SwiftUI

struct CandidateCard: View {

    @Environment(GameManager.self) private var game

    let candidate: Candidate

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.largeTitle)
                    .foregroundStyle(.green)

                VStack(alignment: .leading) {

                    Text(candidate.name)
                        .font(.title3)
                        .bold()

                    Text(candidate.role.rawValue)
                        .foregroundStyle(.secondary)

                }

                Spacer()

            }

            Divider()

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
            role: .researchAssistant,
            skill: 74,
            salary: 5600,
            potential: 97,
            specialty: "Computer Vision"
        )
    )
    .environment(GameManager())

}
//  CandidateCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

