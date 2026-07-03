import Foundation

struct Product: Identifiable {

    let id = UUID()

    var name: String
    var description: String

    var level = 0

    var customers = 0

    var buildCost: Double

    var revenuePerLevel: Double

    var unlocked = true
    
    var requiredTechnology: String?

    var monthlyRevenue: Double {

        Double(customers) * 10

    }

    var dailyGrowth: Int {

        max(level * 5, 1)

    }

}
