//
//  CoachView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import SwiftUI

struct CoachMainView: View {
    @EnvironmentObject var teamModel: TeamModel
    @EnvironmentObject var userModel: UserModel
    
    @State var showNewPlayerView = false
    @State var showNewChallengeMatchView = false
    @State var showNewRegularMatchView = false
    @State var showJoinCodeView = false
    @State var showConfirmDeleteTeam = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    PlayerListView() { selectedPlayer in
                        teamModel.detailPlayer = selectedPlayer
                    }.navigationTitle(teamModel.teamName ?? "Players")
                    
                    NavigationLink(isActive: $teamModel.showPlayerDetailView) {
                        if let player = teamModel.detailPlayer {
                            PlayerDetailView(player: player)
                        }
                    } label: { EmptyView() }

                    NavigationLink(isActive: $showNewPlayerView) {
                        NewPlayerView()
                    } label: { EmptyView() }

                    NavigationLink(isActive: $showNewChallengeMatchView) {
                        NewMatchView(matchType: .challenge)
                    } label: { EmptyView() }

                    NavigationLink(isActive: $showNewRegularMatchView) {
                        NewMatchView(matchType: .regular)
                    } label: { EmptyView() }
                    
                    NavigationLink(isActive: $showNewRegularMatchView) {
                        NewMatchView(matchType: .regular)
                    } label: { EmptyView() }
                    
                    NavigationLink(isActive: $showJoinCodeView) {
                        JoinCodeViews()
                    } label: { EmptyView() }
                }.toolbar {
                    Menu {
                        if let id = userModel.currentUser?.id {
                            Text("Your code: \(id)")
                        }
                        
                        Button {
                            showJoinCodeView = true
                        } label: {
                            Label {
                                Text("See join codes")
                            } icon: {
                                Image(systemName: "person.wave.2")
                            }
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
                        
                        Button(role: .destructive) {
                            showConfirmDeleteTeam = true
                        } label: {
                            Label {
                                Text("Delete Team")
                            } icon: {
                                Image(systemName: "trash.fill")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                    }
                }
            }
            .navigationViewStyle(.stack)
            .confirmationDialog("", isPresented: $showConfirmDeleteTeam) {
                Button(role: .destructive) {
                    guard let coachId  = userModel.coachId else {
                        return
                    }
                    
                    userModel.logOut(teamModel: teamModel)
                    teamModel.deleteTeam(coachId: coachId)
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("Are you sure you want to delete this team?")
            }

            if !showNewPlayerView && !showNewChallengeMatchView &&
                !showNewRegularMatchView && !teamModel.showPlayerDetailView &&
                !showJoinCodeView {
                AddButtonArrayView() { action in
                    switch action {
                    case .addChallengeMatch:
                        showNewChallengeMatchView = true
                    case .addPlayer:
                        showNewPlayerView = true
                    case .addRegularMatch:
                        showNewRegularMatchView = true
                    }
                }
            }
        }
    }
}

struct CoachMainView_Previews: PreviewProvider {
    static var previews: some View {
        CoachMainView()
            .environmentObject(TeamModel())
    }
}
