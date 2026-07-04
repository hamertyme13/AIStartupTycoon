import SwiftUI

struct TimeControls: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        HStack(spacing: 20) {

            ForEach(GameSpeed.allCases, id: \.self) { speed in

                Button {

                    game.gameSpeed = speed

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

        }

    }

}
//  TimeControls.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

