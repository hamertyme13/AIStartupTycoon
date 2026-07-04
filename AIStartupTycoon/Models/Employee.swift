import Foundation

enum EmployeeRole: String, CaseIterable {

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

struct Employee: Identifiable {

    let id = UUID()

    let name: String
    
    var role: EmployeeRole

    var salary: Double

    var skill: Int
    
    var specialty: String
    
    var potential: Int
    
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

        return (Double(skill) / 100.0) * roleBonus

    }
    
    var researchOutput: Double {

        switch role {

        // Engineers
        case .juniorEngineer:
            return 0.5

        case .engineer:
            return 1.0

        case .seniorEngineer:
            return 2.0

        case .staffEngineer:
            return 3.0

        case .principalEngineer:
            return 4.0

        case .distinguishedEngineer:
            return 5.0

        // Research Path
        case .researchAssistant:
            return 3.0

        case .researchScientist:
            return 5.0

        case .seniorScientist:
            return 7.0

        case .principalScientist:
            return 9.0

        case .chiefScientist:
            return 12.0

        // Management
        case .productManager:
            return 0.5

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
