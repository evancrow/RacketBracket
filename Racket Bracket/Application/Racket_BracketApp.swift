//
//  Racket_BracketApp.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/16/22.
//

import SwiftUI

@main
struct Racket_BracketApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
