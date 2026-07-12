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

    enum CompanyPerk: String, CaseIterable, Identifiable, Codable {

        case hiringBrand = "Hiring Brand"
        case customerSuccessOps = "Customer Success Ops"
        case cloudNegotiator = "Cloud Negotiator"
        case founderDiscipline = "Founder Discipline"
        case boardWhisperer = "Board Whisperer"
        case frontierOperator = "Frontier Operator"

        var id: String {
            rawValue
        }

        var cost: Int {

            switch self {

            case .hiringBrand,
                 .customerSuccessOps:
                return 1

            case .cloudNegotiator,
                 .founderDiscipline:
                return 2

            case .boardWhisperer,
                 .frontierOperator:
                return 3

            }

        }

        var summary: String {

            switch self {

            case .hiringBrand:
                return "Improves morale and reduces poaching risk."

            case .customerSuccessOps:
                return "Customer success sprints are more effective."

            case .cloudNegotiator:
                return "Reduces infrastructure and frontier project pressure."

            case .founderDiscipline:
                return "Monthly operations create more perk momentum."

            case .boardWhisperer:
                return "Improves active investor relationships."

            case .frontierOperator:
                return "Speeds up frontier lab mega-projects."

            }

        }

    }

    enum ContractKind: String, Codable {

        case contract = "Contract"
        case enterprisePilot = "Enterprise Pilot"
        case governmentGrant = "Government Grant"

    }

    struct ContractOpportunity: Identifiable, Codable {

        var id = UUID()
        let name: String
        let kind: ContractKind
        let payout: Double
        let reputationEffect: Int
        let satisfactionEffect: Int
        let researchEffect: Double
        let durationMonths: Int

    }

    struct MarketSegment: Identifiable, Codable {

        var id = UUID()
        let name: String
        let description: String
        let unlockCost: Double
        let monthlyRevenueBonus: Double
        let reputationRequired: Int
        var unlocked: Bool = false
        var localShare: Double = 0

    }

    struct FrontierProject: Identifiable, Codable {

        var id = UUID()
        let name: String
        let description: String
        let requiredTechnology: String?
        let totalCost: Double
        let valuationReward: Double
        let reputationReward: Int
        let researchReward: Double
        var progress: Double = 0
        var completed: Bool = false

    }

    enum GameAchievement: String, CaseIterable, Identifiable, Codable {

        case firstHire = "First Hire"
        case firstContract = "First Contract"
        case customerHero = "Customer Hero"
        case founderControl = "Founder Control"
        case unicornBuilder = "Unicorn Builder"
        case frontierLab = "Frontier Lab"
        case globalExpansion = "Global Expansion"
        case loyalTeam = "Loyal Team"

        var id: String {
            rawValue
        }

        var gameCenterID: String {
            "com.roguecircuit.aistartuptycoon." +
                rawValue
                .lowercased()
                .replacingOccurrences(of: " ", with: "_")
        }

        var summary: String {

            switch self {

            case .firstHire:
                return "Hire your first employee."

            case .firstContract:
                return "Complete contract or enterprise pilot work."

            case .customerHero:
                return "Reach 90% customer satisfaction."

            case .founderControl:
                return "Reach $10M value while keeping 80% ownership."

            case .unicornBuilder:
                return "Reach a $1B valuation."

            case .frontierLab:
                return "Complete a frontier lab mega-project."

            case .globalExpansion:
                return "Unlock three market segments."

            case .loyalTeam:
                return "Keep average loyalty above 85 with at least five employees."

            }

        }

    }

    // MARK: Company Info

    var name = "Rogue AI Labs"

    var playerName = "Founder"
    
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

    var companyPerkPoints = 0

    var unlockedCompanyPerks: Set<CompanyPerk> = []

    var completedContracts = 0

    var availableContracts: [ContractOpportunity] = []

    var unlockedAchievements: Set<GameAchievement> = []
    
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
            focus: .research,
            personality: .technical,
            contribution: Investor.Contribution(
                title: "Research Credits",
                summary: "Boosts research velocity and grants an immediate research reserve.",
                researchMultiplierBonus: 0.20,
                revenueMultiplierBonus: 0,
                monthlyRevenueBoost: 0,
                marketShareBonus: 0,
                reputationBonus: 3,
                valuationBonus: 150_000,
                customerGrowthBonus: 0,
                researchPointGrant: 150,
                candidateBoost: 0
            )
        ),

        Investor(
            name: "Y Combinator",
            investment: 500_000,
            equity: 20,
            description: "Startup accelerator focused on rapid company growth.",
            focus: .growth,
            personality: .operatorMindset,
            contribution: Investor.Contribution(
                title: "Startup Operating Playbook",
                summary: "Improves customer growth and brings more candidates into the hiring market.",
                researchMultiplierBonus: 0,
                revenueMultiplierBonus: 0.08,
                monthlyRevenueBoost: 1_000,
                marketShareBonus: 1,
                reputationBonus: 4,
                valuationBonus: 300_000,
                customerGrowthBonus: 0.08,
                researchPointGrant: 0,
                candidateBoost: 2
            )
        ),

        Investor(
            name: "Sequoia Capital",
            investment: 1_000_000,
            equity: 25,
            description: "Global venture capital firm investing in world-changing companies.",
            focus: .enterprise,
            personality: .aggressive,
            contribution: Investor.Contribution(
                title: "Enterprise Expansion",
                summary: "Adds enterprise revenue, valuation lift, and market credibility.",
                researchMultiplierBonus: 0,
                revenueMultiplierBonus: 0.12,
                monthlyRevenueBoost: 4_000,
                marketShareBonus: 2,
                reputationBonus: 5,
                valuationBonus: 1_200_000,
                customerGrowthBonus: 0.04,
                researchPointGrant: 0,
                candidateBoost: 1
            )
        ),

        Investor(
            name: "Rogue Circuit Capital",
            investment: 350_000,
            equity: 12,
            description: "Founder-friendly seed fund backing sharp technical teams.",
            focus: .recruiting,
            personality: .connector,
            contribution: Investor.Contribution(
                title: "Talent Network",
                summary: "Expands recruiting reach and improves reputation without heavy dilution.",
                researchMultiplierBonus: 0.05,
                revenueMultiplierBonus: 0,
                monthlyRevenueBoost: 500,
                marketShareBonus: 0.5,
                reputationBonus: 6,
                valuationBonus: 200_000,
                customerGrowthBonus: 0.03,
                researchPointGrant: 50,
                candidateBoost: 3
            )
        ),

        Investor(
            name: "Greylock Operators Guild",
            investment: 750_000,
            equity: 18,
            description: "Operator-led investors who care about durable execution.",
            focus: .enterprise,
            personality: .patient,
            contribution: Investor.Contribution(
                title: "Go-To-Market Bench",
                summary: "Improves revenue quality and opens enterprise buyer channels.",
                researchMultiplierBonus: 0,
                revenueMultiplierBonus: 0.10,
                monthlyRevenueBoost: 2_500,
                marketShareBonus: 1.2,
                reputationBonus: 3,
                valuationBonus: 650_000,
                customerGrowthBonus: 0.02,
                researchPointGrant: 0,
                candidateBoost: 1
            )
        ),

        Investor(
            name: "Contrary Signal Fund",
            investment: 180_000,
            equity: 8,
            description: "Small check, unusual conviction, minimal control pressure.",
            focus: .growth,
            personality: .contrarian,
            contribution: Investor.Contribution(
                title: "Contrarian Narrative",
                summary: "Adds reputation and early buzz while preserving ownership.",
                researchMultiplierBonus: 0,
                revenueMultiplierBonus: 0.04,
                monthlyRevenueBoost: 250,
                marketShareBonus: 0.8,
                reputationBonus: 5,
                valuationBonus: 125_000,
                customerGrowthBonus: 0.05,
                researchPointGrant: 0,
                candidateBoost: 0
            )
        ),

        Investor(
            name: "Frontier Compute Partners",
            investment: 1_500_000,
            equity: 30,
            description: "Deep-pocketed fund with access to scarce compute and AI labs.",
            focus: .frontier,
            personality: .visionary,
            contribution: Investor.Contribution(
                title: "Compute Allocation",
                summary: "Greatly accelerates frontier research at the cost of heavy dilution.",
                researchMultiplierBonus: 0.30,
                revenueMultiplierBonus: 0,
                monthlyRevenueBoost: 0,
                marketShareBonus: 1,
                reputationBonus: 7,
                valuationBonus: 2_000_000,
                customerGrowthBonus: 0,
                researchPointGrant: 350,
                candidateBoost: 1
            )
        ),

        Investor(
            name: "Main Street Angels",
            investment: 90_000,
            equity: 5,
            description: "Local angel syndicate offering patient capital and early customers.",
            focus: .enterprise,
            personality: .patient,
            contribution: Investor.Contribution(
                title: "First Customer Network",
                summary: "Adds modest revenue and keeps the founder firmly in control.",
                researchMultiplierBonus: 0,
                revenueMultiplierBonus: 0.02,
                monthlyRevenueBoost: 800,
                marketShareBonus: 0.3,
                reputationBonus: 2,
                valuationBonus: 60_000,
                customerGrowthBonus: 0.02,
                researchPointGrant: 0,
                candidateBoost: 0
            )
        )

    ]
    
    // MARK: - Board of Directors

    var activeInvestors: [Investor] = []

    var marketSegments: [MarketSegment] = [

        MarketSegment(
            name: "Startup Teams",
            description: "Fast-moving founders and small teams adopting practical AI.",
            unlockCost: 15_000,
            monthlyRevenueBonus: 1_500,
            reputationRequired: 40,
            unlocked: true,
            localShare: 12
        ),
        MarketSegment(
            name: "Enterprise Buyers",
            description: "Large customers with strict security and reliability needs.",
            unlockCost: 65_000,
            monthlyRevenueBonus: 8_000,
            reputationRequired: 60
        ),
        MarketSegment(
            name: "Developer Tools",
            description: "Technical users who reward strong models and fast workflows.",
            unlockCost: 110_000,
            monthlyRevenueBonus: 14_000,
            reputationRequired: 65
        ),
        MarketSegment(
            name: "Public Sector",
            description: "Slow sales cycles, high trust requirements, durable contracts.",
            unlockCost: 180_000,
            monthlyRevenueBonus: 24_000,
            reputationRequired: 75
        ),
        MarketSegment(
            name: "Global AI Platforms",
            description: "International expansion with massive upside and heavy scrutiny.",
            unlockCost: 400_000,
            monthlyRevenueBonus: 60_000,
            reputationRequired: 85
        )

    ]

    var frontierProjects: [FrontierProject] = [

        FrontierProject(
            name: "AGI Safety Institute",
            description: "A dedicated lab for alignment, evaluations, and model governance.",
            requiredTechnology: "Artificial General Intelligence",
            totalCost: 750_000,
            valuationReward: 2_500_000,
            reputationReward: 8,
            researchReward: 500
        ),
        FrontierProject(
            name: "Sovereign Compute Cluster",
            description: "A proprietary compute base that reduces dependence on cloud shortages.",
            requiredTechnology: nil,
            totalCost: 500_000,
            valuationReward: 1_800_000,
            reputationReward: 3,
            researchReward: 300
        ),
        FrontierProject(
            name: "Autonomous Agent Network",
            description: "A platform of agent workflows for enterprise automation.",
            requiredTechnology: "AI Agents",
            totalCost: 350_000,
            valuationReward: 1_200_000,
            reputationReward: 4,
            researchReward: 220
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

    var supportCapacity: Double {

        let productEmployees = employees.filter {
            $0.department == .product
        }.count

        let engineeringEmployees = employees.filter {
            $0.department == .engineering
        }.count

        let capacity =
            Double(productEmployees * 3 + engineeringEmployees)

        let customerLoad =
            max(1, products.reduce(0) { $0 + $1.customers } / 1_000)

        return min(1.5, max(0.35, capacity / Double(customerLoad)))

    }

    var customerSuccessCost: Double {

        let customerScale =
            Double(max(1, totalCustomers / 1_000))

        return 1_500 + customerScale * 350

    }

    var totalCustomers: Int {

        products.reduce(0) {
            $0 + $1.customers
        }

    }

    var unlockedTechnologyCount: Int {

        technologies.filter {
            $0.unlocked
        }.count

    }

    var releasedAIModelCount: Int {

        aiModels.filter {
            $0.status == .released
        }.count

    }

    var unlockedProductCount: Int {

        products.filter {
            $0.unlocked
        }.count

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

            bonus += investor.contribution.researchMultiplierBonus

        }

        return bonus

    }

    var revenueMultiplier: Double {

        var bonus = 1.0

        for investor in activeInvestors {

            bonus += investor.contribution.revenueMultiplierBonus

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
