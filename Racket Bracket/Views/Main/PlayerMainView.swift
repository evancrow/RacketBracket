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
                    
                    Button {
                        userModel.logOut(teamModel: teamModel)
                    } label: {
                        Label {
                            Text("Sign out of team")
                        } icon: {
                            Image(systemName: "eject")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct PlayerMainView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerMainView()
    }
}
