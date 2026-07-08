import Foundation

struct Candidate: Identifiable, Codable {

    var id = UUID()

    let name: String

    let gender: EmployeeGender

    let role: EmployeeRole

    let careerPath: EmployeeCareerPath

    let skill: Int

    let salary: Double

    let potential: Int

    let specialty: String

    let avatar: EmployeeAvatar

    init(
        id: UUID = UUID(),
        name: String,
        gender: EmployeeGender,
        role: EmployeeRole,
        careerPath: EmployeeCareerPath? = nil,
        skill: Int,
        salary: Double,
        potential: Int,
        specialty: String,
        avatar: EmployeeAvatar? = nil
    ) {

        let resolvedPath = careerPath ?? EmployeeCareerPath(role: role)

        self.id = id
        self.name = name
        self.gender = gender
        self.role = role
        self.careerPath = resolvedPath
        self.skill = skill
        self.salary = salary
        self.potential = potential
        self.specialty = specialty
        self.avatar = avatar ?? EmployeeAvatar.random(for: gender)

    }

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case gender
        case role
        case careerPath
        case skill
        case salary
        case potential
        case specialty
        case avatar

    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(EmployeeRole.self, forKey: .role)
        let gender = try container.decodeIfPresent(
            EmployeeGender.self,
            forKey: .gender
        ) ?? .nonBinary

        self.init(
            id: try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID(),
            name: try container.decode(String.self, forKey: .name),
            gender: gender,
            role: role,
            careerPath: try container.decodeIfPresent(
                EmployeeCareerPath.self,
                forKey: .careerPath
            ) ?? EmployeeCareerPath(role: role),
            skill: try container.decode(Int.self, forKey: .skill),
            salary: try container.decode(Double.self, forKey: .salary),
            potential: try container.decode(Int.self, forKey: .potential),
            specialty: try container.decode(String.self, forKey: .specialty),
            avatar: try container.decodeIfPresent(
                EmployeeAvatar.self,
                forKey: .avatar
            ) ?? EmployeeAvatar.random(for: gender)
        )

    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(gender, forKey: .gender)
        try container.encode(role, forKey: .role)
        try container.encode(careerPath, forKey: .careerPath)
        try container.encode(skill, forKey: .skill)
        try container.encode(salary, forKey: .salary)
        try container.encode(potential, forKey: .potential)
        try container.encode(specialty, forKey: .specialty)
        try container.encode(avatar, forKey: .avatar)

    }

}
//  Candidate.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//
