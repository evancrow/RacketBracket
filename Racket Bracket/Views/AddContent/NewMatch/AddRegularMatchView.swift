//
//  AddRegularMatchView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

struct AddRegularMatchView: View {
    @EnvironmentObject var teamModel: TeamModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var player: Player?
    @State var partner: Player?
    @State var isWinner: Bool = false
    @State var winnerPoints = ""
    @State var loserPoints = ""
    
    var canContinue: Bool {
        player != nil && !winnerPoints.isEmpty && !loserPoints.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SelectPlayerSectionView(player: $player, title: "Player", exludePlayers: [partner])
            SelectPlayerSectionView(
                player: $partner,
                title: "Doubles Partner",
                subtitle: "optional",
                exludePlayers: [player])
            
            Checkbox(selected: $isWinner, title: "Won the match")
                .padding(.bottom)
            
            SetScoreView(winnerPoints: $winnerPoints, loserPoints: $loserPoints)
                .padding(.bottom)
            
            Spacer()
            
            RoundedButton(title: "Add Another Match") {
                createMatchAndUpdateRanks()
                
                player = nil
                partner = nil
                isWinner = false
                
                winnerPoints = ""
                loserPoints = ""
            }.disabled(!canContinue)
            
            RoundedButton(title: "Save & Close") {
                createMatchAndUpdateRanks()
                presentationMode.wrappedValue.dismiss()
            }.disabled(!canContinue)
        }.padding([.horizontal, .bottom])
    }
    
    private func createMatchAndUpdateRanks() {
        guard let player = player,
            let winnerPoints = Int(winnerPoints),
            let loserPoints = Int(loserPoints) else {
            return
        }
        
        let winner: Player? = isWinner ? player : nil
        let loser: Player? = !isWinner ? player : nil

        if let partner = partner {
            let doublesMatch = DoublesMatch(
                winner: winner,
                loser: loser,
                partner: partner,
                setScore: (winnerPoints, loserPoints))
            
            RankingModel.shared.updateRanks(doublesMatch: doublesMatch, teamModel: teamModel)
        } else {
            let match = Match(
                winner: winner,
                loser: loser,
                matchType: .regular,
                setScore: (winnerPoints, loserPoints))
            
            RankingModel.shared.updateRanks(with: match, teamModel: teamModel)
        }
    }
}

struct AddRegularMatchView_Previews: PreviewProvider {
    static var previews: some View {
        AddRegularMatchView()
            .environmentObject(TeamModel(addMockPlayers: true))
    }
}
