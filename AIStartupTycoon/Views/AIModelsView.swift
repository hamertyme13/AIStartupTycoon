import SwiftUI

struct AIModelsView: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    ForEach(game.company.aiModels.indices, id: \.self) { index in

                        AIModelCard(
                            model: game.company.aiModels[index]
                        )

                    }

                }
                .padding()

            }
            .navigationTitle("AI Models")

        }

    }

}

#Preview {

    AIModelsView()
        .environment(GameManager())

}
//  AIModelsView.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

