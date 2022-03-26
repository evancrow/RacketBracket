//
//  PlayerWinLoseRationView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

struct PlayerWinLoseRationView: View {
    let player: Player
    
    var ratio: Double {
        if player.matches.count > 0 {
           return Double(player.matchesWon.count) / Double(player.matches.count)
        } else {
            return 0
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(String(player.matchesWon.count))
                        .font(.title)
                    
                    Text("Wins")
                        .bold()
                }.foregroundColor(.mint)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(String(player.matchesLost.count))
                        .font(.title)
                    
                    Text("Losses")
                        .bold()
                }.foregroundColor(.red)
            }
            
            ProgressBar(progress: ratio, showOpposingProgress: player.matches.count > 0)
        }
    }
}

struct PlayerWinLoseRationView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerWinLoseRationView(player: Player.mockPlayer())
    }
}
