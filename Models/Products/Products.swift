import Foundation

enum ProductStrategy: String, CaseIterable, Identifiable, Codable {

    case balanced = "Balanced"
    case growth = "Growth"
    case enterprise = "Enterprise"
    case reliability = "Reliability"
    case research = "Research"

    var id: String {
        rawValue
    }

    var summary: String {

        switch self {

        case .balanced:
            return "Stable revenue, growth, and customer trust."

        case .growth:
            return "Faster adoption with more support pressure."

        case .enterprise:
            return "Higher revenue per customer but slower adoption."

        case .reliability:
            return "Improves satisfaction and reduces churn pressure."

        case .research:
            return "Turns product usage into research insight."

        }

    }

    var growthMultiplier: Double {

        switch self {

        case .balanced:
            return 1.0

        case .growth:
            return 1.35

        case .enterprise:
            return 0.75

        case .reliability:
            return 0.85

        case .research:
            return 0.90

        }

    }

    var revenueMultiplier: Double {

        switch self {

        case .balanced:
            return 1.0

        case .growth:
            return 0.92

        case .enterprise:
            return 1.35

        case .reliability:
            return 1.05

        case .research:
            return 0.95

        }

    }

    var satisfactionEffect: Int {

        switch self {

        case .balanced,
             .enterprise:
            return 0

        case .growth:
            return -1

        case .reliability:
            return 2

        case .research:
            return 1

        }

    }

}

struct Product: Identifiable, Codable {

    var id = UUID()

    var name: String
    var description: String

    var level = 0

    var customers = 0

    var buildCost: Double

    var revenuePerLevel: Double

    var unlocked = true
    
    var requiredTechnology: String?

    var strategy: ProductStrategy = .balanced

    var monthlyRevenue: Double {

        Double(customers) * 10 * strategy.revenueMultiplier

    }

    var dailyGrowth: Int {

        max(Int(Double(max(level * 5, 1)) * strategy.growthMultiplier), 1)

    }

}
