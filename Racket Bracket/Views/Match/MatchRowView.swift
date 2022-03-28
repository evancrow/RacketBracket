//
//  MatchRowView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

struct MatchRowView: View {
    var match: Match
    var player: Player
    
    var didWin: Bool {
        match.winner == player
    }
    
    var opponent: Player? {
        if let winner = match.winner, winner != player {
            return winner
        } else if let loser = match.loser, loser != player {
            return loser
        }
        
        return nil
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(didWin ? "Winner" : "Loser")
                        .fontWeight(.semibold)
                    
                    Text("\(match.setScore.0) - \(match.setScore.1)")
                    
                    Spacer()
                }.font(.title2)
                
                HStack {
                    if let opponent = opponent {
                        Text("vs. ")
                            .fontWeight(.regular)
                        
                        NavigationLink {
                            PlayerDetailView(player: opponent)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                        .background(
                            HStack {
                                Text(opponent.fullName)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                
                                
                                Spacer()
                            }
                        )
                    }
                    
                    Spacer()
                }.font(.headline)
            }
            
            Spacer()
            
            RankChange(pointsGained: RankingModel.shared.caluclatePoints(with: match, forWin: didWin))
        }.padding().frame(maxWidth: .infinity).background(Color.defaultBackground.cornerRadius(12))
    }
}

struct MatchRowView_Previews: PreviewProvider {
    static var previews: some View {
        let match = Match.mockChallengeMatch()
        MatchRowView(match: match, player: match.winner!)
    }
}
