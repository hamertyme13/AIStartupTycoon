import Foundation

struct Investor: Identifiable, Codable {

    var id = UUID()

    let name: String

    let investment: Double

    let equity: Double

    let description: String

    let focus: Focus

    var invested = false

    var investedDate: String?

    enum Focus: String, Codable {

        case research = "Research"
        case growth = "Growth"
        case enterprise = "Enterprise"
        case recruiting = "Recruiting"
        case frontier = "Frontier AI"

    }

}
