//
//  ContentView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/16/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var teamModel: TeamModel
    @ObservedObject private var userModel: UserModel

    var body: some View {
        Group {
            if let user = userModel.currentUser {
                if user.type == .coach {
                    CoachMainView()
                } else {
                    PlayerMainView()
                }
            } else {
                SignInView()
            }
        }
        .environmentObject(teamModel)
        .environmentObject(userModel)
        .alert("You've Been Logged Out", isPresented: $userModel.showForcedLoggedOutAlert) {
            Button {
                userModel.showForcedLoggedOutAlert = false
            } label: {
                Text("Okay")
            }
        } message: {
            Text("You might have been removed from the team or it no longer exists.")
        }
    }
    
    init() {
        let userModel = UserModel()
        
        self.teamModel = TeamModel(userModel: userModel)
        self.userModel = userModel
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
