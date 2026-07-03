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

    // MARK: Reputation

    var reputation = 0

    // MARK: News

    var latestNews = "🚀 Welcome to AI Startup Tycoon!"

    // MARK: Employees

    var employees: [Employee] = [

        Employee(
            name: "You",
            role: .juniorEngineer,
            salary: 0,
            skill: 50
        )

    ]

    // MARK: Products

    var products: [Product] = [

        Product(
            name: "AI Chatbot",
            description: "Customer Support AI",
            buildCost: 1000,
            revenuePerLevel: 100
        ),

        Product(
            name: "Image Generator",
            description: "AI Image Creation",
            buildCost: 5000,
            revenuePerLevel: 350,
            unlocked: false
        ),

        Product(
            name: "Coding Assistant",
            description: "AI Software Engineer",
            buildCost: 12000,
            revenuePerLevel: 800,
            unlocked: false
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

        return max((employeeScore + revenueScore) / 2, 0.20)

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

}
