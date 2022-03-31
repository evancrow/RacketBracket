//
//  PlayerDetailview.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

struct PlayerDetailView: View {
    @ObservedObject var player: Player
    @EnvironmentObject var teamModel: TeamModel
    @EnvironmentObject var userModel: UserModel
    
    @State var nameHeight: CGFloat = 0
    @State var renaming = false
    @State var matchFilter: MatchType?
    
    var matches: [Match] {
        if let matchFilter = matchFilter {
            return player.matches.filter { $0.matchType == matchFilter }
        } else {
            return player.matches
        }
    }
    
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
    
    var filter: some View {
        Menu {
            Button {
                matchFilter = .regular
            } label: {
                Label {
                    Text("Regular Matches")
                } icon: {
                    if matchFilter == .regular {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                matchFilter = .challenge
            } label: {
                Label {
                    Text("Challenge Matches")
                } icon: {
                    if matchFilter == .challenge {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                matchFilter = nil
            } label: {
                Label {
                    Text("All")
                } icon: {
                    if matchFilter == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: matchFilter == nil ?
                  "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                .font(.title3)
        }
    }
    
    @ViewBuilder
    var matchesList: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Matches")
                    .font(.title)
                    .bold()
                    .foregroundColor(.label)
                
                Spacer()
                
                filter
            }
            
            if player.matches.count > 0 {
                ScrollView(showsIndicators: false) {
                    ForEach(matches) { match in
                        MatchRowView(match: match, player: player)
                    }
                }
            } else if userModel.canWriteDate {
                Text("The player's matches will display here! You can add a match by tapping + on the home page.")
                    .fontWeight(.medium)
                    .padding(.top)
            }
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu {
                Button {
                    renaming = true
                } label: {
                    Label {
                        Text("Rename")
                    } icon: {
                        Image(systemName: "pencil")
                    }
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
}

struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlayerDetailView(player: Player.mockPlayer())
            
        }
        
        NavigationView {
            PlayerDetailView(player: Player.mockPlayer(), matchFilter: .regular)
        }
        
        NavigationView {
            PlayerDetailView(player: Player.mockPlayer(addMatch: false))
        }
    }
}
