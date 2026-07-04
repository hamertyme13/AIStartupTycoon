import Foundation

struct HiringManager {

    static let firstNames = [

        "Emily",
        "Alex",
        "Sarah",
        "James",
        "Olivia",
        "Daniel",
        "Sophia",
        "Michael",
        "Emma",
        "Noah"

    ]

    static let lastNames = [

        "Carter",
        "Chen",
        "Williams",
        "Johnson",
        "Brown",
        "Garcia",
        "Lee",
        "Wilson"

    ]

    static let specialties = [

        "LLMs",
        "Computer Vision",
        "Voice AI",
        "Backend Systems",
        "Distributed AI",
        "Reinforcement Learning",
        "AI Safety",
        "Robotics"

    ]
    
    static let availableRoles: [EmployeeRole] = [

        .juniorEngineer,
        .engineer,
        .researchAssistant,
        .productManager

    ]

    static func generateCandidate() -> Candidate {

        let skill = Int.random(in: 45...85)

        let salary = Double(skill * 100)

        return Candidate(

            name: "\(firstNames.randomElement()!) \(lastNames.randomElement()!)",

            role: availableRoles.randomElement()!,

            skill: skill,

            salary: salary,

            potential: Int.random(in: 60...99),

            specialty: specialties.randomElement()!

        )

    }

}
//  HiringManager.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

