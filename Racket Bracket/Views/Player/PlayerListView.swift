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
    
    @State private var showConfirmDelete = false
    @State private var playerToDelete: Player? = nil
    
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
                }.onDelete(perform: delete).id(UUID())
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
                
                if !selectMode && userModel.canWriteDate {
                    players.onDelete(perform: delete).id(UUID())
                } else {
                    players
                }
            } header: {
                Text("Not Ranked (no games played)")
            }
        }.useEffect(deps: nameFilter) { _ in
            updateFilteredPlayers()
        }.onChange(of: teamModel.players) { _ in
            updateFilteredPlayers()
        }.refreshable {
            teamModel.retrieveDataFromCloud()
        }.confirmationDialog("Delete Player?", isPresented: $showConfirmDelete) {
            Button(role: .destructive) {
                DispatchQueue.main.async {
                    teamModel.players.removeAll { player in
                        player == playerToDelete
                    }
                    
                    teamModel.savePlayers()
                }
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete this player?")
        }
    }
    
    private func delete(with indexSet: IndexSet) {
        showConfirmDelete = true

        indexSet.forEach {
            playerToDelete =  teamModel.players[$0]
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
