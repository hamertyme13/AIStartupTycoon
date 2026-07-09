import SwiftUI
import Combine

struct DashboardView: View {
    
    @Environment(GameManager.self) private var game
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 28) {
                    
                    // MARK: - TODAY
                    
                    dashboardSection("TODAY")
                    
                    CEOHeaderCard()
                    
                    CompanyHealthCard()
                    
                    Divider()
                    
                    // MARK: - DECISIONS
                    
                    dashboardSection("DECISIONS")
                    
                    CEOBriefingCard()
                    
                    ObjectivesCard()
                    
                    Divider()
                    
                    // MARK: - BUSINESS
                    
                    dashboardSection("BUSINESS")
                    
                    CashFlowCard()

                    AIProjectionCard()
                    
                    Divider()
                    
                    // MARK: - WORLD
                    
                    dashboardSection("WORLD")
                    
                    NewsCard()
                    
                    Divider()
                    
                    // MARK: - TIME
                    
                    dashboardSection("TIME")
                    
                    MonthProgressCard(
                        elapsed: game.secondsElapsed,
                        total: game.secondsPerMonth
                    )
                    
                    TimeControls()
                    
                }
                .padding()
                
            }
            .scrollContentBackground(.hidden)
            .background(RogueCircuitTheme.appBackground.ignoresSafeArea())
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .preferredColorScheme(.dark)
        .onReceive(timer) { _ in
            
            guard game.gameOutcome == nil else {
                return
            }

            guard game.currentEvent == nil else {
                return
            }
            
            guard game.gameSpeed != .paused else {
                return
            }
            
            game.advanceOneSecond()
            
            game.secondsElapsed += 1
            
            if game.secondsElapsed >= game.secondsPerMonth {
                
                game.secondsElapsed = 0
                
                game.nextMonth()
                
            }
            
        }
        
    }
        
    @ViewBuilder
    func dashboardSection(_ title: String) -> some View {
        
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundStyle(RogueCircuitTheme.signalGreen)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textCase(.uppercase)
        
    }
        
}

struct AIProjectionCard: View {

    @Environment(GameManager.self) private var game

    private var projectedCash90Days: Double {
        game.company.cash + (game.company.monthlyProfit * 3)
    }

    private var projectedRevenue90Days: Double {
        let growthRate = max(0.02, game.company.customerGrowthMultiplier * 0.08)
        return game.company.monthlyRevenue * pow(1 + growthRate, 3)
    }

    private var projectionTone: Color {

        if projectedCash90Days < 0 ||
           game.company.customerSatisfaction < 55 {
            return .orange
        }

        if projectedRevenue90Days > game.company.monthlyRevenue * 1.25 &&
           game.company.monthlyProfit > 0 {
            return RogueCircuitTheme.signalGreen
        }

        return RogueCircuitTheme.electricCyan

    }

    private var recommendation: String {

        if game.company.researchExpense > game.company.monthlyRevenue * 0.45 {
            return "Research burn is heavy. Raise capital, increase revenue, or pause before runway tightens."
        }

        if game.company.runwayMonths < 4 {
            return "Runway is thin. Prioritize revenue, fundraising, or lower expenses this month."
        }

        if game.company.customerSatisfaction < 65 {
            return "Customer satisfaction is dragging growth. Shift staff toward product quality."
        }

        if game.company.monthlyProfit > 0 &&
           game.company.releasedAIModelCount < 2 {
            return "You have room to invest. Accelerate research or train another AI model."
        }

        return "Trajectory is stable. Keep balancing product growth, research, and cash discipline."

    }

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            HStack {

                Label(
                    "AI Projections",
                    systemImage: "sparkles"
                )
                .font(.headline)
                .foregroundStyle(RogueCircuitTheme.signalGreen)

                Spacer()

                Text("90D")
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundStyle(RogueCircuitTheme.void)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(RogueCircuitTheme.signalGreen)
                    .clipShape(Capsule())

            }

            Text(recommendation)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            HStack(spacing: 12) {

                projectionMetric(
                    title: "Cash",
                    value: "$\(Int(projectedCash90Days).formatted())",
                    color: projectionTone
                )

                projectionMetric(
                    title: "Revenue",
                    value: "$\(Int(projectedRevenue90Days).formatted())",
                    color: RogueCircuitTheme.electricCyan
                )

            }

            HStack(spacing: 12) {

                projectionMetric(
                    title: "Runway",
                    value: "\(Int(game.company.runwayMonths)) mo",
                    color: game.company.runwayMonths >= 6
                    ? RogueCircuitTheme.signalGreen
                    : .orange
                )

                projectionMetric(
                    title: "Risk",
                    value: riskLabel,
                    color: riskColor
                )

            }

        }
        .padding()
        .rogueCircuitCard(cornerRadius: 20)

    }

    private var riskLabel: String {

        if projectedCash90Days < 0 {
            return "High"
        }

        if game.company.customerSatisfaction < 65 ||
           game.company.runwayMonths < 6 {
            return "Medium"
        }

        return "Low"

    }

    private var riskColor: Color {

        switch riskLabel {

        case "High":
            return .red

        case "Medium":
            return .orange

        default:
            return RogueCircuitTheme.signalGreen

        }

    }

    private func projectionMetric(
        title: String,
        value: String,
        color: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(color)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(color.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(color.opacity(0.22), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))

    }

}
#Preview {
        
    DashboardView()
        .environment(GameManager())
        
}
