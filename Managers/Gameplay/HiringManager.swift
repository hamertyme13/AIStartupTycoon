import Foundation

struct HiringManager {

    static let feminineFirstNames = [

        "Emily",
        "Sarah",
        "Olivia",
        "Sophia",
        "Emma",
        "Maya",
        "Aisha",
        "Priya",
        "Isabella",
        "Zoe",
        "Nora",
        "Chloe",
        "Amara",
        "Grace",
        "Lina",
        "Mei",
        "Valeria",
        "Hannah",
        "Leah",
        "Naomi",
        "Ava"

    ]

    static let masculineFirstNames = [

        "James",
        "Daniel",
        "Michael",
        "Noah",
        "Liam",
        "Ethan",
        "Mateo",
        "Lucas",
        "Owen",
        "Elijah",
        "Mason",
        "Kai",
        "Julian",
        "Arjun",
        "Leo",
        "Theo",
        "Samuel",
        "Nico",
        "Andre",
        "Caleb"

    ]

    static let neutralFirstNames = [

        "Alex",
        "Jordan",
        "Taylor",
        "Riley",
        "Morgan",
        "Casey",
        "Avery",
        "Quinn",
        "Rowan",
        "Skyler",
        "Reese",
        "Sage",
        "Dakota",
        "Emerson",
        "Finley",
        "Parker",
        "Remy",
        "River"

    ]

    static let lastNames = [

        "Carter",
        "Chen",
        "Williams",
        "Johnson",
        "Brown",
        "Garcia",
        "Lee",
        "Wilson",
        "Patel",
        "Nguyen",
        "Kim",
        "Singh",
        "Martinez",
        "Davis",
        "Miller",
        "Lopez",
        "Anderson",
        "Thomas",
        "Moore",
        "Jackson",
        "Martin",
        "Thompson",
        "White",
        "Harris",
        "Clark",
        "Lewis",
        "Robinson",
        "Walker",
        "Young",
        "Allen",
        "King",
        "Wright",
        "Scott"

    ]

    static let specialties = [

        "LLMs",
        "Computer Vision",
        "Voice AI",
        "Backend Systems",
        "Distributed AI",
        "Reinforcement Learning",
        "AI Safety",
        "Robotics",
        "Growth Loops",
        "Developer Tools",
        "Data Infrastructure",
        "Model Evaluation",
        "Enterprise Sales AI",
        "Agent Workflows",
        "Mobile AI",
        "Personalization",
        "Inference Optimization",
        "Prompt Systems",
        "Trust and Safety",
        "Healthcare AI"

    ]
    
    static let availableCareerPaths: [EmployeeCareerPath] = [

        .engineering,
        .research,
        .product,
        .growth

    ]

    static func generateCandidate() -> Candidate {

        let gender = EmployeeGender.allCases.randomElement()!
        let careerPath = availableCareerPaths.randomElement()!
        let level = 1
        let role = careerPath.role(for: level)
        let skill = Int.random(in: 45...85)

        let salary = Double(skill * 100)
        let firstName: String

        switch gender {

        case .female:
            firstName = feminineFirstNames.randomElement()!

        case .male:
            firstName = masculineFirstNames.randomElement()!

        case .nonBinary:
            firstName = neutralFirstNames.randomElement()!

        }

        return Candidate(

            name: "\(firstName) \(lastNames.randomElement()!)",

            gender: gender,

            role: role,

            careerPath: careerPath,

            skill: skill,

            salary: salary,

            potential: Int.random(in: 60...99),

            specialty: specialties.randomElement()!,

            avatar: EmployeeAvatar.random(for: gender)

        )

    }

}
//  HiringManager.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
