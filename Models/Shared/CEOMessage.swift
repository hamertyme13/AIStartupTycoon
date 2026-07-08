import Foundation

struct CEOMessage: Identifiable, Codable {

    var id = UUID()

    let priority: Priority

    let title: String

    let message: String

    enum Priority: Int, Codable {

        case critical = 0
        case attention = 1
        case opportunity = 2
        case industry = 3

    }

}
//  CEOMessage.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/4/26.
//
