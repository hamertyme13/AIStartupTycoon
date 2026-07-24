import Foundation

struct AIModel: Identifiable, Codable {

    var id = UUID()

    let name: String

    let description: String

    let requiredTechnology: String

    let trainingCost: Double

    let requiredResearch: Double

    let revenueBonus: Double

    let marketShareBonus: Double

    let valuationBonus: Double

    var status: AIModelStatus = .locked

    var trainingProgress: Double = 0

}
