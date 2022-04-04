//
//  MatchRowView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

struct MatchRowView: View {
    @EnvironmentObject var teamModel: TeamModel
    
    var match: Match
    var player: Player
    
    var didWin: Bool {
        match.playerDidWin(player)
    }
    
    var winner: Player? {
        if let winner = match.winnerId {
            return teamModel.players.first { $0.userId == winner }
        }
        
        return nil
    }
    
    var loser: Player? {
        if let loser = match.loserId {
            return teamModel.players.first { $0.userId == loser }
        }
        
        return nil
    }
    
    var opponent: Player? {
        if let winner = winner, winner != player {
            return winner
        } else if let loser = loser, loser != player {
            return loser
        }
        
        return nil
    }
    
    // For Doubles
    var isDoublesMatch: Bool {
        return match is DoublesMatch
    }
    
    var partner: Player? {
        guard let doublesMatch = match as? DoublesMatch else {
            return nil
        }
        
        if doublesMatch.partnerId != player.userId {
            return teamModel.players.first { $0.userId == doublesMatch.partnerId }
        } else if didWin {
            return winner
        } else {
            return loser
        }
    }
    
    var otherPlayer: Player? {
        isDoublesMatch ? partner : opponent
    }

    @State var showOpponentNavigationView = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(match.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
                
                HStack {
                    Text(didWin ? "Winner" : "Loser")
                        .fontWeight(.semibold)
                    
                    Text("\(match.setScore.0) - \(match.setScore.1)")
                    
                    Spacer()
                }.font(.title2)
                
                HStack {
                    if let otherPlayer = otherPlayer {
                        Text(isDoublesMatch ? "with " : "vs. ")
                            .fontWeight(.regular)
                        
                        Text(otherPlayer.fullName)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                showOpponentNavigationView = true
                            }
                        
                        Spacer()
                        
                        NavigationLink(isActive: $showOpponentNavigationView) {
                            PlayerDetailView(player: otherPlayer)
                        } label: {
                            EmptyView()
                        }.opacity(0)
                    }
                    
                    Spacer()
                }.font(.headline)
            }
            
            Spacer()
         
            RankChange(pointsGained: RankingModel.shared.caluclatePoints(
                with: match,
                winner: winner,
                loser: loser,
                forWin: didWin)
            )
        }.padding().frame(maxWidth: .infinity).background(Color.defaultBackground.cornerRadius(12))
    }
}
