import SwiftUI

struct CEOBriefingCard: View {

    @Environment(GameManager.self) private var game

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            Label(
                "CEO Briefing",
                systemImage: "exclamationmark.bubble.fill"
            )
            .font(.headline)

            Divider()
            
            if game.company.ceoBriefing.isEmpty {
                
                ContentUnavailableView(
                    "Nothing Needs Your Attention",
                    systemImage: "checkmark.circle.fill",
                    description: Text("Your executive team has no urgent updates.")
                )
                
            } else {
                
                ForEach(
                    game.company.ceoBriefing.sorted {
                        $0.priority.rawValue < $1.priority.rawValue
                    }
                    ) { message in
                    
                    CEOMessageRow(message: message)
                    
                }
                
            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

   

}

#Preview {

    CEOBriefingCard()
        .environment(GameManager())

}
//  CEOBriefingCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//
