//
//  NewPlayerView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct NewPlayerView: View {
    @EnvironmentObject var playerModel: PlayerModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var playerFirstName = ""
    @State var playerLastName = ""
    
    var player: Player? = nil
    
    var editing: Bool {
        player != nil
    }
    
    var disabled: Bool {
        playerFirstName.isEmpty || playerLastName.isEmpty
    }
    
    var body: some View {
        VStack {
            RoundedTextField(placeholder: "Player first name", textFieldValue: $playerFirstName)
            RoundedTextField(placeholder: "Player last name", textFieldValue: $playerLastName)
            
            Spacer()
            
            if !editing {
                RoundedButton(title: "Add Another Player") {
                    playerModel.addPlayer(with: playerFirstName, lastName: playerLastName)
                    playerFirstName = ""
                    playerLastName = ""
                }.disabled(disabled)
            }
            
            RoundedButton(title: "Save & Close") {
                if editing, let player = player {
                    player.firstName = playerFirstName
                    player.lastName = playerLastName
                    playerModel.savePlayers()
                } else {
                    playerModel.addPlayer(with: playerFirstName, lastName: playerLastName)
                }
               
                presentationMode.wrappedValue.dismiss()
            }.disabled(disabled)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationTitle("New Player")
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
