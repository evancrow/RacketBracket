//
//  NewTeamView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import SwiftUI

struct NewTeamView: View {
    @EnvironmentObject var teamModel: TeamModel
    @EnvironmentObject var userModel: UserModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var teamName = ""
    
    var body: some View {
        VStack {
            RoundedTextField(placeholder: "Team name", textFieldValue: $teamName)
            
            Spacer()
            
            RoundedButton(title: "Next") {
                teamModel.createTeam(with: teamName)
                userModel.createUser(type: .coach)
                
                presentationMode.wrappedValue.dismiss()
            }.disabled(teamName.isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationTitle("New Team")
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        NewTeamView()
    }
}
