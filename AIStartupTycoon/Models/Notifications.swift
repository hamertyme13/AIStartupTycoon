import Foundation

struct CompanyNotification: Identifiable {

    let id = UUID()

    let title: String

    let message: String

    let year: Int

    let month: Int

    let date = Date()

}
//  Notifications.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 7/3/26.
//

