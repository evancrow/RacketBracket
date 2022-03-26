//
//  PlayerDetailview.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

struct PlayerDetailView: View {
    @ObservedObject var player: Player
    @EnvironmentObject var playerModel: PlayerModel
    
    @State var nameHeight: CGFloat = 0
    @State var renaming = false
    
    var rankName: some View {
        HStack {
            if player.rank.rawScore > 0 {
                Text("#\(player.rank.value)")
                    .font(.system(size: nameHeight + 10, weight: .regular))
                    .padding(.trailing)
            }
            
            VStack(alignment: .leading) {
                Text(player.firstName)
                    .fontWeight(.bold)
                    .font(.title)
                
                Text(player.lastName)
                    .fontWeight(.bold)
                    .font(.title)
            }.background(
                GeometryReader { geom in
                    Color.clear.useEffect(deps: geom.size) { _ in
                        nameHeight = geom.size.height
                    }
                }
            )
            
            Spacer()
        }
    }
    
    var score: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(player.rank.rawScore)")
                    .fontWeight(.bold)
                    .font(.title)
                
                if player.rank.rawScore == 0 {
                    Text("(not currently ranked)")
                }
            }
            
            Text("raw score")
        }
    }
    
    @ViewBuilder
    var matchesList: some View {
        if player.matches.count > 0 {
            List {
                Section {
                    ForEach(player.matches) { match in
                        MatchRowView(match: match, player: player)
                    }.onDelete(perform: deleteMatch).id(UUID())
                } header: {
                    Text("Matches")
                        .font(.title)
                        .bold()
                        .padding(-20)
                        .padding(.bottom, 24)
                        .foregroundColor(.label)
                }
            }.padding(-20)
        } else {
            Text("The player's matches will display here! You can add a match by tapping + on the home page.")
                .fontWeight(.medium)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                rankName
                score
                PlayerWinLoseRationView(player: player)
                Spacer()
            }.padding()
            
            OverlaySheetView {
                matchesList
                    .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu {
                Button {
                    renaming = true
                } label: {
                    Text("Rename")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        
        NavigationLink(isActive: $renaming) {
            NewPlayerView(player: player)
        } label: {
            EmptyView()
        }
    }
    
    private func deleteMatch(with indexSet: IndexSet) {
        indexSet.forEach { RankingModel.shared.delete(match: player.matches[$0], playerModel: playerModel) }
    }
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlayerDetailView(player: Player.mockPlayer(addMatch: false))
        }
    }
}
