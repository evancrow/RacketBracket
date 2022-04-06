//
//  PlayerRowView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct PlayerRowView: View {
    var player: Player
    var altName: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(altName ?? player.fullName)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack {
                    if player.rank.rawScore > 0 {
                        Text("#" + String(player.rank.value))
                            .fontWeight(.semibold)
                    }
                    
                    Text(String(player.rank.rawScore))
                    
                    Spacer()
                }.font(.title2)
            }.padding()
        }.background(Color.defaultBackground)
    }
}

struct PlayerRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerRowView(player: Player.mockPlayer())
    }
}
