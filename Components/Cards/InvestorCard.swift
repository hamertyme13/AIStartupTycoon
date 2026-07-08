import SwiftUI

struct InvestorCard: View {
    
    let investor: Investor
    
    let accept: () -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                
                VStack(alignment: .leading) {
                    
                    HStack {

                        Image(systemName: "building.columns.fill")
                            .foregroundStyle(RogueCircuitTheme.electricCyan)

                        Text(investor.name)
                            .font(.title2)
                            .bold()

                    }
                    
                    Text(investor.description)
                        .foregroundStyle(.secondary)

                    Label(
                        investor.personality.rawValue,
                        systemImage: "person.text.rectangle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(RogueCircuitTheme.signalGreen)
                    
                }
                
                Spacer()
                
                if investor.invested {
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.green)
                    
                }
                
            }
            
            Divider()

            VStack(alignment: .leading, spacing: 6) {

                Label(
                    investor.focus.rawValue,
                    systemImage: "scope"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Text(investor.personality.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(investor.contribution.title)
                    .font(.headline)

                Text(investor.contribution.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)

            }
            
            if investor.invested {
                
                Label("Invested", systemImage: "checkmark.circle.fill")
                
                Label("\(Int(investor.equity))% Ownership",
                      systemImage: "chart.pie.fill")
                    .foregroundStyle(.orange)
                
                Label(
                    "$\(Int(investor.investment).formatted())",
                    systemImage: "banknote.fill"
                )
                .foregroundStyle(.green)
                
                Text(investor.investedDate ?? "Not Invested")
                    .foregroundStyle(.secondary)
                
            } else {
                
                Text("Investment")
                    .bold()
                
                Text("$\(Int(investor.investment).formatted())")
                
                Text("Equity Requested")
                
                Text("\(Int(investor.equity))%")

                contributionGrid
                
                Button {
                    
                    accept()
                    
                } label: {
                    
                    Label("Accept Investment",
                          systemImage: "dollarsign.circle.fill")
                    
                }
                .buttonStyle(.borderedProminent)
                
            }
            
        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)
    }

    private var contributionGrid: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            alignment: .leading,
            spacing: 8
        ) {

            if investor.contribution.researchMultiplierBonus > 0 {
                perk(
                    "Research",
                    "+\(Int(investor.contribution.researchMultiplierBonus * 100))%"
                )
            }

            if investor.contribution.revenueMultiplierBonus > 0 {
                perk(
                    "Revenue",
                    "+\(Int(investor.contribution.revenueMultiplierBonus * 100))%"
                )
            }

            if investor.contribution.monthlyRevenueBoost > 0 {
                perk(
                    "MRR",
                    "+$\(Int(investor.contribution.monthlyRevenueBoost).formatted())"
                )
            }

            if investor.contribution.reputationBonus > 0 {
                perk("Reputation", "+\(investor.contribution.reputationBonus)")
            }

            if investor.contribution.marketShareBonus > 0 {
                perk(
                    "Share",
                    "+\(String(format: "%.1f", investor.contribution.marketShareBonus))%"
                )
            }

            if investor.contribution.researchPointGrant > 0 {
                perk("Research Grant", "+\(Int(investor.contribution.researchPointGrant)) RP")
            }

            if investor.contribution.candidateBoost > 0 {
                perk("Candidates", "+\(investor.contribution.candidateBoost)")
            }

            if investor.contribution.customerGrowthBonus > 0 {
                perk(
                    "Growth",
                    "+\(Int(investor.contribution.customerGrowthBonus * 100))%"
                )
            }

        }
        .font(.caption)

    }

    private func perk(
        _ title: String,
        _ value: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 2) {

            Text(title)
                .foregroundStyle(.secondary)

            Text(value)
                .bold()

        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RogueCircuitTheme.electricCyan.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 8))

    }
    
}
#Preview {

    InvestorCard(
        investor: Investor(
            name: "OpenAI Ventures",
            investment: 250000,
            equity: 15,
            description: "AI Startup Fund",
            focus: .research
        )
    ) {

    }

}
//  InvestorCard.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/2/26.
//
