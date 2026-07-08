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
            .foregroundStyle(RogueCircuitTheme.electricCyan)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textCase(.uppercase)
        
    }
        
}
#Preview {
        
    DashboardView()
        .environment(GameManager())
        
}
