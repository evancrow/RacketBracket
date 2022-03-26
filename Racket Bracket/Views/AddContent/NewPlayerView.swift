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
    
    @State var playerName = ""
    
    var body: some View {
        VStack {
            RoundedTextField(placeholder: "Player name", textFieldValue: $playerName)
            
            Spacer()
            
            RoundedButton(title: "Add Another Player") {
                playerModel.addPlayer(with: playerName)
                playerName = ""
            }.disabled(playerName.isEmpty)
            
            RoundedButton(title: "Save & Close") {
                playerModel.addPlayer(with: playerName)
                presentationMode.wrappedValue.dismiss()
            }.disabled(playerName.isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationTitle("New Player")
    }
}

struct NewPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayerView()
    }
}
