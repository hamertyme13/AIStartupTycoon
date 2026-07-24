import Foundation

enum AIModelStatus: String, Codable {

    case locked

    case readyToTrain

    case training

    case readyToRelease

    case released

}
//  AIModelStatus.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//

