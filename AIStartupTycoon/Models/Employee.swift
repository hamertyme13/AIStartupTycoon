import Foundation

enum EmployeeRole: String, CaseIterable {
    case juniorEngineer = "Junior Engineer"
    case seniorEngineer = "Senior Engineer"
    case aiResearcher = "AI Researcher"
}

struct Employee: Identifiable {

    let id = UUID()

    let name: String
    let role: EmployeeRole

    let salary: Double

    let skill: Int

    var productivity: Double {
        Double(skill) / 100.0
    }
}
