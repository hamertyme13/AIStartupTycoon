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
                            .foregroundStyle(.blue)

                        Text(investor.name)
                            .font(.title2)
                            .bold()

                    }
                    
                    Text(investor.description)
                        .foregroundStyle(.secondary)
                    
                }
                
                Spacer()
                
                if investor.invested {
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.green)
                    
                }
                
            }
            
            Divider()
            
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
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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

