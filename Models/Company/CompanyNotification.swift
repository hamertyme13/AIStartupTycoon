import Foundation

struct CompanyNotification: Identifiable, Codable {

    var id = UUID()

    let title: String

    let message: String

    let year: Int

    let month: Int

    var date = Date()

}
//  Notifications.swift
//  TechEmpire
//
//  Created by Joshua Hamer on 7/3/26.
//
