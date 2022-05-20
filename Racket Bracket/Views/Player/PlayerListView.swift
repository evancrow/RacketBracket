//
//  PlayerList.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct PlayerListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var teamModel: TeamModel
    @EnvironmentObject var userModel: UserModel
    
    @State private var nameFilter = ""
    @State private var filteredPlayers: [Player] = []
    
    var detailPlayer: Player? = nil
    var excluding: [Player?] = []
    var selectMode = false
    var playerSelected: ((Player) -> Void)?
    
    var body: some View {
        List {
            if selectMode {
                Section {
                    RoundedTextField(placeholder: "Search a name", textFieldValue: $nameFilter)
                        .listRowInsets(EdgeInsets())
                        .navigationBarTitle("Select Player")
                }
            }
            
            if let detailPlayer = detailPlayer {
                Button {
                    if let playerSelected = playerSelected {
                        playerSelected(detailPlayer)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    PlayerRowView(player: detailPlayer, altName: "Your Profile")
                        .id(detailPlayer.id)
                }
            }
            
            Section {
                ForEach(filteredPlayers.filter { $0.matches.count > 0 }) { player in
                    Button {
                        if let playerSelected = playerSelected {
                            playerSelected(player)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        PlayerRowView(player: player)
                            .id(player.id)
                    }
                }.id(UUID())
            } header: {
                Text("Ranked")
            }
            
            Section {
                let players = ForEach(filteredPlayers.filter { $0.matches.count == 0 }) { player in
                    Button {
                        if let playerSelected = playerSelected {
                            playerSelected(player)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        PlayerRowView(player: player)
                            .id(player.id)
                    }
                }
                
                players.id(UUID())
            } header: {
                Text("Not Ranked (no games played)")
            }
        }.useEffect(deps: nameFilter) { _ in
            updateFilteredPlayers()
        }.onChange(of: teamModel.players) { _ in
            updateFilteredPlayers()
        }.refreshable {
            teamModel.retrieveDataFromCloud()
        }
    }
    
    private func updateFilteredPlayers() {
        filteredPlayers = teamModel.playersRanked.filter {
            ($0.fullName.contains(nameFilter) || nameFilter.isEmpty || !selectMode) && !excluding.contains($0)
        }
    }
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
            .environmentObject(TeamModel(addMockPlayers: true))
        
        PlayerListView(selectMode: true)
            .environmentObject(TeamModel(addMockPlayers: true))
    }
}
