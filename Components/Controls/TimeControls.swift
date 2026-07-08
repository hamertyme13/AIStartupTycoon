import SwiftUI

struct TimeControls: View {

    @Environment(GameManager.self) private var game

    @State private var showingResetConfirmation = false

    var body: some View {

        HStack(spacing: 20) {

            ForEach(GameSpeed.allCases, id: \.self) { speed in

                Button {

                    game.gameSpeed = speed
                    game.saveGame()

                } label: {

                    Image(systemName: speed.icon)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background(
                            game.gameSpeed == speed
                            ? Color.blue
                            : Color.gray.opacity(0.2)
                        )
                        .foregroundStyle(
                            game.gameSpeed == speed
                            ? .white
                            : .primary
                        )
                        .clipShape(Circle())

                }
                

            }
            
            Button {

                game.skipToNextMonth()

            } label: {

                Image(systemName: "forward.end.fill")
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .clipShape(Circle())

            }

            Button {

                game.saveGame()

            } label: {

                Image(systemName: "square.and.arrow.down.fill")
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color.blue.opacity(0.85))
                    .foregroundStyle(.white)
                    .clipShape(Circle())

            }

            Button {

                showingResetConfirmation = true

            } label: {

                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(Color.red.opacity(0.85))
                    .foregroundStyle(.white)
                    .clipShape(Circle())

            }

        }
        .confirmationDialog(
            "Start a new company?",
            isPresented: $showingResetConfirmation,
            titleVisibility: .visible
        ) {

            Button("New Game", role: .destructive) {

                game.resetGame()

            }

            Button("Cancel", role: .cancel) {}

        }

    }

}
//  TimeControls.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//
