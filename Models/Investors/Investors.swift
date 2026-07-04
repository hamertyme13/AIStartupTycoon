import Foundation

struct Investor: Identifiable {

    let id = UUID()

    let name: String

    let investment: Double

    let equity: Double

    let description: String

    let focus: Focus

    var invested = false

    var investedDate: String?

    enum Focus: String {

        case research = "Research"
        case growth = "Growth"
        case enterprise = "Enterprise"
        case recruiting = "Recruiting"
        case frontier = "Frontier AI"

    }

}
