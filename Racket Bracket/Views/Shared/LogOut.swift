//
//  LogOutButton.swift
//  Racket Bracket
//
//  Created by Evan Crow on 5/20/22.
//

import SwiftUI

struct LogOutButton: View {
    @Binding var showConfirmation: Bool
    
    var body: some View {
        Button {
            showConfirmation = true
        } label: {
            Label {
                Text("Sign out of team")
            } icon: {
                Image(systemName: "eject")
            }
        }
    }
}

extension View {
    func addLogOutConfirmation(teamModel: TeamModel, userModel: UserModel, showConfirmation: Binding<Bool>) -> some View {
        self.confirmationDialog("", isPresented: showConfirmation) {
            Button(role: .destructive) {
                userModel.logOut(teamModel: teamModel)
            } label: {
                Text("Sign Out")
            }
        } message: {
            Text("Are you sure you want to sign out? REMEMBER your \(userModel.isCoach ? "team" : "join") code since it's the only way to log back in.")
        }
    }
}
