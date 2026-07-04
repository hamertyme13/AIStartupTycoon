import SwiftUI

struct InnovationView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink {

                    ResearchView()

                } label: {

                    Label(
                        "Research",
                        systemImage: "brain.head.profile"
                    )

                }

                NavigationLink {

                    AIModelsView()

                } label: {

                    Label(
                        "AI Models",
                        systemImage: "cpu.fill"
                    )

                }

            }

            .navigationTitle("Innovation")

        }

    }

}

#Preview {

    InnovationView()

}
//  InnovationView.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//

