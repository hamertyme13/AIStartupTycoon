import Foundation
import Observation

@Observable
class Company {

    enum CampaignStage: String, Codable {

        case garage = "Garage Startup"
        case seed = "Seed Stage"
        case growth = "Growth Stage"
        case scaleUp = "Scale-Up"
        case frontierLab = "Frontier Lab"

    }

    enum Scenario: String, CaseIterable, Identifiable, Codable {

        case bootstrappedFounder = "Bootstrapped Founder"
        case vcRocketShip = "VC Rocket Ship"
        case aiWinter = "AI Winter"
        case openSourceWar = "Open Source War"

        var id: String {
            rawValue
        }

        var subtitle: String {

            switch self {

            case .bootstrappedFounder:
                return "Low cash, full control, careful growth."

            case .vcRocketShip:
                return "More money, less ownership, faster expectations."

            case .aiWinter:
                return "Demand is weak and runway matters."

            case .openSourceWar:
                return "Competitors are aggressive and market share is harder."

            }

        }

        var startingCash: Double {

            switch self {

            case .bootstrappedFounder:
                return 8_000

            case .vcRocketShip:
                return 150_000

            case .aiWinter:
                return 25_000

            case .openSourceWar:
                return 50_000

            }

        }

        var startingOwnership: Double {

            switch self {

            case .bootstrappedFounder,
                 .aiWinter,
                 .openSourceWar:
                return 100

            case .vcRocketShip:
                return 82

            }

        }

        var startingReputation: Int {

            switch self {

            case .bootstrappedFounder:
                return 45

            case .vcRocketShip:
                return 58

            case .aiWinter:
                return 42

            case .openSourceWar:
                return 52

            }

        }

        var demandMultiplier: Double {

            switch self {

            case .bootstrappedFounder,
                 .vcRocketShip:
                return 1.0

            case .aiWinter:
                return 0.75

            case .openSourceWar:
                return 0.9

            }

        }

    }

    struct WorldEvent: Identifiable, Codable {

        var id = UUID()

        let title: String
        let summary: String
        let demandMultiplier: Double
        let churnMultiplier: Double
        let researchMultiplier: Double
        let reputationEffect: Int
        let durationMonths: Int

    }

    // MARK: Company Info

    var name = "My AI Startup"
    
    var ceoBriefing: [CEOMessage] = []

    // MARK: Economy

    var cash: Double = 10_000
    var monthlyRevenue: Double = 250
    var companyValue: Double = 25_000
    var marketShare: Double = 70
    var lifetimeRevenue: Double = 0
    var customerSatisfaction = 78
    var churnRisk: Double = 0.02
    var selectedScenario: Scenario = .bootstrappedFounder
    var activeWorldEvent: WorldEvent?
    var activeWorldEventMonthsRemaining = 0
    var completedTutorialSteps: Set<String> = []
    
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
            skill: 50,
            specialty: "Startup Founder",
            potential: 100
        )

    ]
    
    var talentMarket: [Candidate] = []
    
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
            description: "AI-focused venture capital firm specializing in frontier research.",
            focus: .research
        ),

        Investor(
            name: "Y Combinator",
            investment: 500_000,
            equity: 20,
            description: "Startup accelerator focused on rapid company growth.",
            focus: .growth
        ),

        Investor(
            name: "Sequoia Capital",
            investment: 1_000_000,
            equity: 25,
            description: "Global venture capital firm investing in world-changing companies.",
            focus: .enterprise
        )

    ]
    
    // MARK: - Board of Directors

    var activeInvestors: [Investor] = []
    
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
    
    var companyStatus: String {

        if cash < 10_000 {

            return "🔴 In Trouble"

        }

        if monthlyProfit < 0 {

            return "🟠 Struggling"

        }

        if marketShare >= 30 {

            return "🟢 Thriving"

        }

        return "🟡 Growing"

    }

    var campaignStage: CampaignStage {

        if hasUnlockedTechnology("Artificial General Intelligence") {

            return .frontierLab

        }

        if companyValue >= 10_000_000 ||
           monthlyRevenue >= 50_000 {

            return .scaleUp

        }

        if companyValue >= 1_000_000 ||
           employees.count >= 8 {

            return .growth

        }

        if activeInvestors.isEmpty {

            return .garage

        }

        return .seed

    }

    var productQuality: Double {

        let productEmployees = employees.filter {
            $0.department == .product
        }.count

        let engineeringEmployees = employees.filter {
            $0.department == .engineering
        }.count

        let staffingScore =
            Double(productEmployees * 2 + engineeringEmployees)

        let customerLoad =
            max(1, products.reduce(0) { $0 + $1.customers } / 750)

        return min(1.25, max(0.55, staffingScore / Double(customerLoad)))

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
    
    var aiModels: [AIModel] = [

        AIModel(
            name: "Neuron-1",
            description: "First conversational AI model.",
            requiredTechnology: "Chatbots",
            trainingCost: 25_000,
            requiredResearch: 100,
            revenueBonus: 500,
            marketShareBonus: 2,
            valuationBonus: 100_000
        ),

        AIModel(
            name: "Vision-X",
            description: "Generates realistic images.",
            requiredTechnology: "Image Generation",
            trainingCost: 100_000,
            requiredResearch: 250,
            revenueBonus: 2_000,
            marketShareBonus: 4,
            valuationBonus: 500_000
        ),

        AIModel(
            name: "Echo",
            description: "Advanced voice assistant.",
            requiredTechnology: "Voice AI",
            trainingCost: 350_000,
            requiredResearch: 500,
            revenueBonus: 7_500,
            marketShareBonus: 7,
            valuationBonus: 1_500_000
        ),

        AIModel(
            name: "Atlas",
            description: "Autonomous AI workforce.",
            requiredTechnology: "AI Agents",
            trainingCost: 1_000_000,
            requiredResearch: 1000,
            revenueBonus: 25_000,
            marketShareBonus: 10,
            valuationBonus: 10_000_000
        ),

        AIModel(
            name: "Genesis",
            description: "Artificial General Intelligence.",
            requiredTechnology: "Artificial General Intelligence",
            trainingCost: 10_000_000,
            requiredResearch: 5000,
            revenueBonus: 250_000,
            marketShareBonus: 20,
            valuationBonus: 100_000_000
        )

    ]
    
    func hasUnlockedTechnology(_ name: String) -> Bool {

        technologies.contains {

            $0.name == name && $0.unlocked

        }

    }
    
    var monthlyExpenses: Double {

        let payroll = employees.reduce(0) {
            
            $0 + $1.salary
        }

        return payroll
            + currentOffice.monthlyRent
            + serverCost
            + researchExpense

    }
    
    var monthlyProfit: Double {
        monthlyRevenue - monthlyExpenses
    }
    
    var researchMultiplier: Double {

        var bonus = 1.0

        for investor in activeInvestors {

            switch investor.focus {

            case .research:
                bonus += 0.20

            default:
                break

            }

        }

        return bonus

    }

    var revenueMultiplier: Double {

        var bonus = 1.0

        for investor in activeInvestors {

            switch investor.focus {

            case .growth:
                bonus += 0.10

            case .enterprise:
                bonus += 0.05

            default:
                break

            }

        }

        return bonus

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
    
    // MARK: - Offices
    
    var officeLevel = 0
    
    var offices: [Office] = [

        Office(
            name: "Garage",
            cost: 0,
            monthlyRent: 1_500,
            productivityBonus: 0,
            researchBonus: 0,
            reputationBonus: 0,
            icon: "🏠"
        ),

        Office(
            name: "Shared Workspace",
            cost: 25_000,
            monthlyRent: 3_500,
            productivityBonus: 0.10,
            researchBonus: 0.05,
            reputationBonus: 2,
            icon: "🏢"
        ),

        Office(
            name: "Small Office",
            cost: 100_000,
            monthlyRent: 8_000,
            productivityBonus: 0.20,
            researchBonus: 0.15,
            reputationBonus: 5,
            icon: "🏙️"
        ),

        Office(
            name: "Corporate HQ",
            cost: 500_000,
            monthlyRent: 20_000,
            productivityBonus: 0.35,
            researchBonus: 0.30,
            reputationBonus: 12,
            icon: "🏛️"
        ),

        Office(
            name: "AI Campus",
            cost: 2_000_000,
            monthlyRent: 60_000,
            productivityBonus: 0.50,
            researchBonus: 0.50,
            reputationBonus: 25,
            icon: "🌎"
        )

    ]
    
    var currentOffice: Office {
        offices[officeLevel]
    }
    
 // MARK: Expenses

    var serverCost: Double = 500

    var researchExpense: Double = 0
    
    var competitors: [Competitor] = [

        Competitor(
            name: "NeuralForge AI",
            
            ceo: CEO(
                name: "David Stone",
                title: "Founder & CEO",
                personality: .engineer
            ),
            
            cash: 50_000,
            revenue: 2_000,
            valuation: 500_000,
            employees: 8,
            products: 2,
            marketShare: 8
        ),

        Competitor(
            name: "Titan Intelligence",
            
            ceo: CEO(
                name: "Marcus Hale",
                title: "CEO",
                personality: .dealmaker
            ),
            
            cash: 120_000,
            revenue: 5_500,
            valuation: 1_500_000,
            employees: 14,
            products: 3,
            marketShare: 12
        ),

        Competitor(
            name: "QuantumMind",
            
            ceo: CEO(
                name: "Dr. Elena Park",
                title: "Founder & CEO",
                personality: .visionary
            ),
            
            cash: 80_000,
            revenue: 3_200,
            valuation: 900_000,
            employees: 10,
            products: 2,
            marketShare: 10
        )

    ]
    
    
    
    

}
