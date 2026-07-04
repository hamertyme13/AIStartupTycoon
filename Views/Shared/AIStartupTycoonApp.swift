//
//  AIStartupTycoonApp.swift
//  AIStartupTycoon
//
//  Created by Joshua Hamer on 6/29/26.
//

import SwiftUI

@main
struct AIStartupTycoonApp: App {

    @State private var game = GameManager()

    var body: some Scene {

        WindowGroup {

            MainTabView()
                .environment(game)

        }

    }

}
