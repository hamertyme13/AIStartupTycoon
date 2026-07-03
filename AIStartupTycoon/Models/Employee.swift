import Foundation

enum EmployeeRole: String, CaseIterable {
    case juniorEngineer = "Junior Engineer"
    case seniorEngineer = "Senior Engineer"
    case researchScientist = "Research Scientist"
    case productManager = "Product Manager"
}

struct Employee: Identifiable {

    let id = UUID()

    let name: String
    
    var role: EmployeeRole

    var salary: Double

    var skill: Int
    
    var level = 1

    var experience: Double = 0

    var productivity: Double {
        Double(skill) / 100.0
    }
    
    var researchOutput: Double {

        switch role {

        case .juniorEngineer:
            return 0.5

        case .seniorEngineer:
            return 2.0

        case .researchScientist:
            return 5.0

        case .productManager:
            return 0.2

        }

    }
    
    var experienceNeeded: Double {
        Double(level) * 100
    }
}
