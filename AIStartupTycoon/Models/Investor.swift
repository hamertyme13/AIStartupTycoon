import Foundation

struct Investor: Identifiable {

    let id = UUID()

    let name: String
    let investment: Double
    let equity: Double
    let description: String

    var invested = false

    var investedDate = ""
}
