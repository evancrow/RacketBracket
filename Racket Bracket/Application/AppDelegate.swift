//
//  AppDelegate.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import UIKit
import Foundation
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        return true
    }
}
