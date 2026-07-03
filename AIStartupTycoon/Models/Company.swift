import Foundation
import Observation

@Observable
class Company {

    // MARK: Company Info

    var name = "My AI Startup"

    // MARK: Economy

    var cash: Double = 10_000
    var monthlyRevenue: Double = 250
    var companyValue: Double = 25_000
    var marketShare: Double = 70
    
    // MARK: - Marketing
    
    var marketingBudget: Double = 0
    
    var marketingLevel = 1
    
    var reputation = 50
    
    var customerGrowthMultiplier = 1.0


    // MARK: News

    var latestNews = "🚀 Welcome to AI Startup Tycoon!"
    
    var notifications: [CompanyNotification] = []

    // MARK: Employees

    var employees: [Employee] = [

        Employee(
            name: "You",
            role: .juniorEngineer,
            salary: 0,
            skill: 50
        )

    ]
    
    // MARK: - Research

    var activeResearch: UUID?

    // MARK: Products

    var products: [Product] = [

        Product(
            name: "AI Chatbot",
            description: "Customer Support AI",
            buildCost: 1000,
            revenuePerLevel: 100,
            unlocked: true,
            requiredTechnology: nil
        ),

        Product(
            name: "Image Generator",
            description: "AI Image Creation",
            buildCost: 5000,
            revenuePerLevel: 350,
            unlocked: false,
            requiredTechnology: "Image Generation"
        ),

        Product(
            name: "Voice Assistant",
            description: "Speech AI",
            buildCost: 10000,
            revenuePerLevel: 900,
            unlocked: false,
            requiredTechnology: "Voice AI"
        ),

        Product(
            name: "AI Agent",
            description: "Autonomous Worker",
            buildCost: 50000,
            revenuePerLevel: 3000,
            unlocked: false,
            requiredTechnology: "AI Agents"
        )

    ]
    
    var investors: [Investor] = [

        Investor(
            name: "OpenAI Ventures",
            investment: 250_000,
            equity: 15,
            description: "AI-focused venture capital."
        ),

        Investor(
            name: "Y Combinator",
            investment: 500_000,
            equity: 20,
            description: "Startup accelerator."
        ),

        Investor(
            name: "Sequoia Capital",
            investment: 1_000_000,
            equity: 25,
            description: "Global venture capital firm."
        )

    ]
    
    var founderOwnership = 100.0
    var currentMonth = 1
    var currentYear = 1
    
    var companyHealth: Double {

        let employeeScore = min(Double(employees.count) / 10.0, 1.0)

        let revenueScore = min(monthlyRevenue / 2000.0, 1.0)

        let cashScore: Double

        if monthlyProfit > 0 {
            cashScore = min(cash / 50000.0, 1.0)
        } else {
            cashScore = max(cash / 50000.0, 0.10)
        }

        let health = (employeeScore + revenueScore + cashScore) / 3.0

        return max(health, 0.20)
    }
    
    var researchPoints: Double = 0

    var technologies: [Technology] = [

        Technology(
            name: "Chatbots",
            description: "Build conversational AI products.",
            requiredResearch: 100
        ),

        Technology(
            name: "Image Generation",
            description: "Create AI image products.",
            requiredResearch: 250
        ),

        Technology(
            name: "Voice AI",
            description: "Speech recognition and synthesis.",
            requiredResearch: 500
        ),

        Technology(
            name: "AI Agents",
            description: "Autonomous AI workers.",
            requiredResearch: 1000
        ),

        Technology(
            name: "Artificial General Intelligence",
            description: "The ultimate breakthrough.",
            requiredResearch: 5000
        )

    ]
    
    var monthlyExpenses: Double {

        let payroll = employees.reduce(0) { total, employee in
            total + employee.salary
        }

        return payroll
            + officeRent
            + serverCost
            + researchExpense

    }
    
    var monthlyProfit: Double {
        monthlyRevenue - monthlyExpenses
    }
    
    var burnRate: Double {
        monthlyExpenses
    }
    
    var runwayMonths: Double {

        guard burnRate > 0 else {

            return 999

        }

        return cash / burnRate

    }
 // MARK: Expenses
    
    var officeRent: Double = 1500

    var serverCost: Double = 500

    var researchExpense: Double = 0
    
    var competitors: [Competitor] = [

        Competitor(
            name: "NeuralForge AI",
            cash: 50_000,
            revenue: 2_000,
            valuation: 500_000,
            employees: 8,
            products: 2,
            marketShare: 8
        ),

        Competitor(
            name: "Titan Intelligence",
            cash: 120_000,
            revenue: 5_500,
            valuation: 1_500_000,
            employees: 14,
            products: 3,
            marketShare: 12
        ),

        Competitor(
            name: "QuantumMind",
            cash: 80_000,
            revenue: 3_200,
            valuation: 900_000,
            employees: 10,
            products: 2,
            marketShare: 10
        )

    ]
    
    

}
