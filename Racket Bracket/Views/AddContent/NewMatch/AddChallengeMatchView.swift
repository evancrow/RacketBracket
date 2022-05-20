//
//  AddChallengeMatchView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

struct AddChallengeMatchView: View {
    @EnvironmentObject var teamModel: TeamModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var winner: Player? = nil
    @State var winnerPoints = ""
    
    @State var loser: Player? = nil
    @State var loserPoints = ""
    
    var canContinue: Bool {
        winner != nil && loser != nil && !winnerPoints.isEmpty && !loserPoints.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SelectPlayerSectionView(player: $winner, title: "Winner", exludePlayers: [loser])
            SelectPlayerSectionView(player: $loser, title: "Loser", exludePlayers: [winner])
            
            SetScoreView(winnerPoints: $winnerPoints, loserPoints: $loserPoints)
                .padding(.bottom)
           
            Spacer()
            
            RoundedButton(title: "Add Another Match") {
                createMatchAndUpdateRanks()
                
                winner = nil
                loser = nil
                
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
        guard let winner = winner, let loser = loser,
            let winnerPoints = Int(winnerPoints),
            let loserPoints = Int(loserPoints) else {
            return
        }

        let match = Match(winner: winner, loser: loser, matchType: .challenge, setScore: (winnerPoints, loserPoints))
        RankingModel.shared.updateRanks(with: match, teamModel: teamModel)
    }
}

struct AddChallengeMatchView_Previews: PreviewProvider {
    static var previews: some View {
        AddChallengeMatchView()
    }
}
