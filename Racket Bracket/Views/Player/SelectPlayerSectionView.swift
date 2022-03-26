//
//  SelectPlayerSection.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

struct SelectPlayerSectionView: View {
    @Binding var player: Player?
    
    let title: String
    var exludePlayers: [Player?] = []
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Spacer()
            }
            
            NavigationLink {
                PlayerListView(excluding: exludePlayers, selectMode: true) { player in
                    self.player = player
                }
            } label: {
                if let player = player {
                    PlayerRowView(player: player)
                        .cornerRadius(12)
                } else {
                    RoundedButton(title: "Select", onTap: nil)
                }
            }
        }.padding(.vertical)
    }
}

struct SelectPlayerSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPlayerSectionView(player: .constant(nil), title: "Winner")
        SelectPlayerSectionView(player: .constant(Player.mockPlayer()), title: "Loser")
    }
}
