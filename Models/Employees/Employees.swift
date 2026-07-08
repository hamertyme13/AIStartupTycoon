import Foundation

enum EmployeeRole: String, CaseIterable, Codable {

    case juniorEngineer = "Junior Engineer"

    case engineer = "Engineer"

    case seniorEngineer = "Senior Engineer"

    case staffEngineer = "Staff Engineer"

    case principalEngineer = "Principal Engineer"

    case distinguishedEngineer = "Distinguished Engineer"

    case researchAssistant = "Research Assistant"

    case researchScientist = "Research Scientist"

    case seniorScientist = "Senior Scientist"

    case principalScientist = "Principal Scientist"

    case chiefScientist = "Chief Scientist"

    case productManager = "Product Manager"

}

enum EmployeeDepartment: String, CaseIterable, Identifiable, Codable {

    case engineering = "Engineering"
    case research = "Research"
    case product = "Product"
    case growth = "Growth"

    var id: String {
        rawValue
    }

    var icon: String {

        switch self {

        case .engineering:
            return "hammer.fill"

        case .research:
            return "flask.fill"

        case .product:
            return "shippingbox.fill"

        case .growth:
            return "chart.line.uptrend.xyaxis"

        }

    }

    var productivityMultiplier: Double {

        switch self {

        case .engineering:
            return 1.15

        case .research:
            return 0.85

        case .product:
            return 1.05

        case .growth:
            return 0.90

        }

    }

    var researchMultiplier: Double {

        switch self {

        case .engineering:
            return 0.95

        case .research:
            return 1.30

        case .product:
            return 1.00

        case .growth:
            return 0.70

        }

    }

}

struct Employee: Identifiable, Codable {

    var id = UUID()

    let name: String
    
    var role: EmployeeRole

    var salary: Double

    var skill: Int
    
    var specialty: String
    
    var potential: Int

    var department: EmployeeDepartment = .engineering
    
    var level = 1

    var experience: Double = 0

    var productivity: Double {

        let roleBonus: Double

        switch role {

        case .juniorEngineer:
            roleBonus = 1.0

        case .engineer:
            roleBonus = 1.1

        case .seniorEngineer:
            roleBonus = 1.2

        case .staffEngineer:
            roleBonus = 1.35

        case .principalEngineer:
            roleBonus = 1.5

        case .distinguishedEngineer:
            roleBonus = 1.75

        case .researchAssistant,
             .researchScientist,
             .seniorScientist,
             .principalScientist,
             .chiefScientist,
             .productManager:

            roleBonus = 1.0

        }

        return (Double(skill) / 100.0) *
            roleBonus *
            department.productivityMultiplier

    }
    
    var researchOutput: Double {

        switch role {

        // Engineers
        case .juniorEngineer:
            return 0.5 * department.researchMultiplier

        case .engineer:
            return 1.0 * department.researchMultiplier

        case .seniorEngineer:
            return 2.0 * department.researchMultiplier

        case .staffEngineer:
            return 3.0 * department.researchMultiplier

        case .principalEngineer:
            return 4.0 * department.researchMultiplier

        case .distinguishedEngineer:
            return 5.0 * department.researchMultiplier

        // Research Path
        case .researchAssistant:
            return 3.0 * department.researchMultiplier

        case .researchScientist:
            return 5.0 * department.researchMultiplier

        case .seniorScientist:
            return 7.0 * department.researchMultiplier

        case .principalScientist:
            return 9.0 * department.researchMultiplier

        case .chiefScientist:
            return 12.0 * department.researchMultiplier

        // Management
        case .productManager:
            return 0.5 * department.researchMultiplier

        }

    }
    
    var experienceNeeded: Double {
        Double(level) * 100
    }
}

extension Employee {

    static let preview = Employee(
        name: "Emily",
        role: .seniorEngineer,
        salary: 9000,
        skill: 88,
        specialty: "Computer Vision",
        potential: 95
    )

}
