import Foundation

struct Candidate: Identifiable, Codable {

    var id = UUID()

    let name: String

    let role: EmployeeRole

    let skill: Int

    let salary: Double

    let potential: Int

    let specialty: String

}
//  Candidate.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//
