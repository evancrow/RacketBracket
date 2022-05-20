//
//  PlayerMainView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import SwiftUI

struct PlayerMainView: View {
    @EnvironmentObject var teamModel: TeamModel
    @EnvironmentObject var userModel: UserModel
    
    @State var showConfirmLogOut = false
    
    var userPlayerProfile: Player? {
        teamModel.players.first { $0.userId == userModel.currentUser?.id }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                PlayerListView(detailPlayer: userPlayerProfile) { selectedPlayer in
                    teamModel.detailPlayer = selectedPlayer
                }.navigationTitle(teamModel.teamName ?? "Players")
                
                NavigationLink(isActive: $teamModel.showPlayerDetailView) {
                    if let player = teamModel.detailPlayer {
                        PlayerDetailView(player: player)
                    }
                } label: { EmptyView() }
            }.toolbar {
                Menu {
                    if let id = userModel.currentUser?.id {
                        Text("Your code: \(id)")
                    }
                    
                    LogOutButton(showConfirmation: $showConfirmLogOut)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                }
            }
        }
        .navigationViewStyle(.stack)
        .addLogOutConfirmation(
            teamModel: teamModel,
            userModel: userModel,
            showConfirmation: $showConfirmLogOut
        )
    }
}

struct PlayerMainView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerMainView()
    }
}
