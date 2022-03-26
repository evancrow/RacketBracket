//
//  AddRegularMatchView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

struct AddRegularMatchView: View {
    @EnvironmentObject var playerModel: PlayerModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var player: Player?
    @State var isWinner: Bool = false
    @State var winnerPoints = ""
    @State var loserPoints = ""
    
    var canContinue: Bool {
        player != nil && !winnerPoints.isEmpty && !loserPoints.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SelectPlayerSectionView(player: $player, title: "Player")
            Checkbox(selected: $isWinner, title: "Won the match")
                .padding(.bottom)
            
            SetScoreView(winnerPoints: $winnerPoints, loserPoints: $loserPoints)
            
            Spacer()
            
            RoundedButton(title: "Add Another Match") {
                createMatchAndUpdateRanks()
                
                winnerPoints = ""
                loserPoints = ""
            }.disabled(!canContinue)
            
            RoundedButton(title: "Save & Close") {
                createMatchAndUpdateRanks()
                presentationMode.wrappedValue.dismiss()
            }.disabled(!canContinue)
        }.padding(.horizontal)
    }
    
    private func createMatchAndUpdateRanks() {
        guard let player = player,
            let winnerPoints = Int(winnerPoints),
            let loserPoints = Int(loserPoints) else {
            return
        }
        
        let winner: Player? = isWinner ? player : nil
        let loser: Player? = !isWinner ? player : nil

        let match = Match(winner: winner, loser: loser, matchType: .challenge, setScore: (winnerPoints, loserPoints))
        RankingModel.shared.updateRanks(with: match, playerModel: playerModel)
    }
}

struct AddRegularMatchView_Previews: PreviewProvider {
    static var previews: some View {
        AddRegularMatchView()
            .environmentObject(PlayerModel(addMockPlayers: true))
    }
}
