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

enum EmployeeGender: String, CaseIterable, Codable {

    case female = "Female"
    case male = "Male"
    case nonBinary = "Non-binary"

}

enum EmployeeCareerPath: String, CaseIterable, Identifiable, Codable {

    case engineering = "Engineering"
    case research = "Research"
    case product = "Product"
    case growth = "Growth"

    var id: String {
        rawValue
    }

    var defaultDepartment: EmployeeDepartment {

        switch self {

        case .engineering:
            return .engineering

        case .research:
            return .research

        case .product:
            return .product

        case .growth:
            return .growth

        }

    }

    func title(for level: Int) -> String {

        let titles: [String]

        switch self {

        case .engineering:
            titles = [
                "Junior Engineer",
                "Software Engineer",
                "Senior Engineer",
                "Staff Engineer",
                "Principal Engineer",
                "Distinguished Engineer",
                "Engineering Fellow",
                "Chief Architect"
            ]

        case .research:
            titles = [
                "Research Assistant",
                "Research Scientist",
                "Senior Scientist",
                "Principal Scientist",
                "Research Lead",
                "Chief Scientist",
                "AI Lab Director",
                "Frontier Research Fellow"
            ]

        case .product:
            titles = [
                "Associate Product Manager",
                "Product Manager",
                "Senior Product Manager",
                "Group Product Manager",
                "Director of Product",
                "VP of Product",
                "Chief Product Officer",
                "Product Visionary"
            ]

        case .growth:
            titles = [
                "Growth Associate",
                "Growth Marketer",
                "Growth Lead",
                "Demand Generation Manager",
                "Head of Growth",
                "VP of Growth",
                "Chief Growth Officer",
                "Market Expansion Strategist"
            ]

        }

        return titles[min(max(level, 1), titles.count) - 1]

    }

    func role(for level: Int) -> EmployeeRole {

        switch self {

        case .engineering:
            switch level {
            case 1:
                return .juniorEngineer
            case 2:
                return .engineer
            case 3:
                return .seniorEngineer
            case 4:
                return .staffEngineer
            case 5:
                return .principalEngineer
            default:
                return .distinguishedEngineer
            }

        case .research:
            switch level {
            case 1:
                return .researchAssistant
            case 2:
                return .researchScientist
            case 3:
                return .seniorScientist
            case 4, 5:
                return .principalScientist
            default:
                return .chiefScientist
            }

        case .product,
             .growth:
            return .productManager

        }

    }

}

struct EmployeeAvatar: Codable {

    var skinTone: Int
    var hairColor: Int
    var hairStyle: Int
    var backgroundStyle: Int
    var shirtColor: Int
    var accessory: Int

    static func random(for gender: EmployeeGender) -> EmployeeAvatar {

        let hairStyleRange: ClosedRange<Int>

        switch gender {

        case .female:
            hairStyleRange = 2...6

        case .male:
            hairStyleRange = 0...4

        case .nonBinary:
            hairStyleRange = 0...6

        }

        return EmployeeAvatar(
            skinTone: Int.random(in: 0...5),
            hairColor: Int.random(in: 0...6),
            hairStyle: Int.random(in: hairStyleRange),
            backgroundStyle: Int.random(in: 0...7),
            shirtColor: Int.random(in: 0...7),
            accessory: Int.random(in: 0...5)
        )

    }

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

    var gender: EmployeeGender
    
    var role: EmployeeRole

    var careerPath: EmployeeCareerPath

    var salary: Double

    var skill: Int
    
    var specialty: String
    
    var potential: Int

    var avatar: EmployeeAvatar

    var department: EmployeeDepartment = .engineering

    var morale = 76

    var burnout = 0

    var loyalty = 72
    
    var level = 1

    var experience: Double = 0

    var careerTitle: String {
        careerPath.title(for: level)
    }

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

        let moraleMultiplier =
            0.70 + (Double(morale) / 100.0) * 0.45

        let burnoutPenalty =
            max(0.55, 1 - Double(burnout) / 180.0)

        return (Double(skill) / 100.0) *
            roleBonus *
            department.productivityMultiplier *
            moraleMultiplier *
            burnoutPenalty

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

    init(
        id: UUID = UUID(),
        name: String,
        gender: EmployeeGender = .nonBinary,
        role: EmployeeRole,
        careerPath: EmployeeCareerPath? = nil,
        salary: Double,
        skill: Int,
        specialty: String,
        potential: Int,
        avatar: EmployeeAvatar? = nil,
        department: EmployeeDepartment? = nil,
        morale: Int = 76,
        burnout: Int = 0,
        loyalty: Int = 72,
        level: Int = 1,
        experience: Double = 0
    ) {

        let resolvedPath = careerPath ?? EmployeeCareerPath(role: role)

        self.id = id
        self.name = name
        self.gender = gender
        self.role = role
        self.careerPath = resolvedPath
        self.salary = salary
        self.skill = skill
        self.specialty = specialty
        self.potential = potential
        self.avatar = avatar ?? EmployeeAvatar.random(for: gender)
        self.department = department ?? resolvedPath.defaultDepartment
        self.morale = morale
        self.burnout = burnout
        self.loyalty = loyalty
        self.level = level
        self.experience = experience

    }

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case gender
        case role
        case careerPath
        case salary
        case skill
        case specialty
        case potential
        case avatar
        case department
        case morale
        case burnout
        case loyalty
        case level
        case experience

    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(EmployeeRole.self, forKey: .role)
        let gender = try container.decodeIfPresent(
            EmployeeGender.self,
            forKey: .gender
        ) ?? .nonBinary
        let careerPath = try container.decodeIfPresent(
            EmployeeCareerPath.self,
            forKey: .careerPath
        ) ?? EmployeeCareerPath(role: role)

        self.init(
            id: try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID(),
            name: try container.decode(String.self, forKey: .name),
            gender: gender,
            role: role,
            careerPath: careerPath,
            salary: try container.decode(Double.self, forKey: .salary),
            skill: try container.decode(Int.self, forKey: .skill),
            specialty: try container.decode(String.self, forKey: .specialty),
            potential: try container.decode(Int.self, forKey: .potential),
            avatar: try container.decodeIfPresent(
                EmployeeAvatar.self,
                forKey: .avatar
            ) ?? EmployeeAvatar.random(for: gender),
            department: try container.decodeIfPresent(
                EmployeeDepartment.self,
                forKey: .department
            ) ?? careerPath.defaultDepartment,
            morale: try container.decodeIfPresent(
                Int.self,
                forKey: .morale
            ) ?? 76,
            burnout: try container.decodeIfPresent(
                Int.self,
                forKey: .burnout
            ) ?? 0,
            loyalty: try container.decodeIfPresent(
                Int.self,
                forKey: .loyalty
            ) ?? 72,
            level: try container.decodeIfPresent(Int.self, forKey: .level) ?? 1,
            experience: try container.decodeIfPresent(
                Double.self,
                forKey: .experience
            ) ?? 0
        )

    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(gender, forKey: .gender)
        try container.encode(role, forKey: .role)
        try container.encode(careerPath, forKey: .careerPath)
        try container.encode(salary, forKey: .salary)
        try container.encode(skill, forKey: .skill)
        try container.encode(specialty, forKey: .specialty)
        try container.encode(potential, forKey: .potential)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(department, forKey: .department)
        try container.encode(morale, forKey: .morale)
        try container.encode(burnout, forKey: .burnout)
        try container.encode(loyalty, forKey: .loyalty)
        try container.encode(level, forKey: .level)
        try container.encode(experience, forKey: .experience)

    }
}

extension EmployeeCareerPath {

    init(role: EmployeeRole) {

        switch role {

        case .researchAssistant,
             .researchScientist,
             .seniorScientist,
             .principalScientist,
             .chiefScientist:
            self = .research

        case .productManager:
            self = .product

        default:
            self = .engineering

        }

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
