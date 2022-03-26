//
//  PlayerList.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct PlayerListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var playerModel: PlayerModel
    
    @State private var nameFilter = ""
    @State private var filteredPlayers: [Player] = []
    
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
            
            Section {
                ForEach(filteredPlayers) { player in
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
            }
        }.useEffect(deps: nameFilter) { _ in
            filteredPlayers = playerModel.playersRanked.filter { $0.name.contains(nameFilter) || nameFilter.isEmpty || !selectMode }
        }
    }
    
    private func delete(with indexSet: IndexSet) {
        indexSet.forEach { playerModel.players.remove(at: $0) }
    }
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
            .environmentObject(PlayerModel(addMockPlayers: true))
        
        PlayerListView(selectMode: true)
            .environmentObject(PlayerModel(addMockPlayers: true))
    }
}
