//
//  NewPlayerView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct NewPlayerView: View {
    @EnvironmentObject var teamModel: TeamModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var playerFirstName = ""
    @State var playerLastName = ""
    @FocusState var focusFirstName: Bool
    
    var player: Player? = nil
    
    var editing: Bool {
        player != nil
    }
    
    var disabled: Bool {
        playerFirstName.isEmpty || playerLastName.isEmpty
    }
    
    var body: some View {
        VStack {
            RoundedTextField(placeholder: "Player first name", textFieldValue: $playerFirstName, isFocused: _focusFirstName)
            RoundedTextField(placeholder: "Player last name", textFieldValue: $playerLastName)
            
            Spacer()
            
            if !editing {
                RoundedButton(title: "Add Another Player") {
                    teamModel.addPlayer(with: playerFirstName, lastName: playerLastName)
                    playerFirstName = ""
                    playerLastName = ""
                    focusFirstName = true
                }.disabled(disabled)
            }
            
            RoundedButton(title: "Save & Close") {
                if editing, let player = player {
                    player.firstName = playerFirstName
                    player.lastName = playerLastName
                    teamModel.savePlayers()
                } else {
                    teamModel.addPlayer(with: playerFirstName, lastName: playerLastName)
                }
               
                presentationMode.wrappedValue.dismiss()
            }.disabled(disabled)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationTitle(editing ? "Edit Player" : "New Player")
        .onAppear() {
            if let player = player {
                playerFirstName = player.firstName
                playerLastName = player.lastName
            }
        }
    }
}

struct NewPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayerView()
    }
}
