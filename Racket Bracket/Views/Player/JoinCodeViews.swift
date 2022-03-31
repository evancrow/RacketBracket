//
//  JoinCodeViews.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import SwiftUI

struct JoinCodeViews: View {
    @EnvironmentObject var teamModel: TeamModel
    
    var body: some View {
        List(teamModel.players.sorted { $0.fullName < $1.fullName }) { player in
            VStack(alignment: .leading) {
                Text(player.fullName)
                    .font(.title2)
                    .bold()
                
                Text(player.userId)
                    .font(.title)
            }.padding()
        }.navigationTitle("Join Codes")
    }
}

struct JoinCodeViews_Previews: PreviewProvider {
    static var previews: some View {
        JoinCodeViews()
            .environmentObject(TeamModel(addMockPlayers: true))
    }
}
