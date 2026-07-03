import SwiftUI

struct TechnologyCard: View {

    let technology: Technology

    let research: () -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                VStack(alignment: .leading) {

                    Text(technology.name)
                        .font(.title3)
                        .bold()

                    Text(technology.description)
                        .foregroundStyle(.secondary)

                }

                Spacer()

                if technology.completed {

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.largeTitle)

                }

            }

            ProgressView(
                value: technology.progress,
                total: technology.requiredResearch
            )

            Text("\(Int(technology.progress))/\(Int(technology.requiredResearch)) RP")

            Button {

                research()

            } label: {

                Label("Research",
                      systemImage: "brain.head.profile")

            }
            .buttonStyle(.borderedProminent)
            .disabled(technology.completed)

        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }

}

#Preview {

    TechnologyCard(
        technology: Technology(
            name: "Chatbots",
            description: "Conversational AI",
            requiredResearch: 100
        )
    ) {

    }

}
//  TechnologyCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//

