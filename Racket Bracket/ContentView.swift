//
//  ContentView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/16/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var playerModel = PlayerModel()

    @State var showNewPlayerView = false
    @State var showNewChallengeMatchView = false
    @State var showNewRegularMatchView = false

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    PlayerListView()
                        .navigationTitle("Players")

                    NavigationLink(isActive: $showNewPlayerView) {
                        NewPlayerView()
                    } label: { EmptyView() }

                    NavigationLink(isActive: $showNewChallengeMatchView) {
                        NewMatchView(matchType: .challenge)
                    } label: { EmptyView() }

                    NavigationLink(isActive: $showNewRegularMatchView) {
                        NewMatchView(matchType: .regular)
                    } label: { EmptyView() }
                }
            }

            if !showNewPlayerView && !showNewChallengeMatchView &&
                !showNewRegularMatchView {
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
        }.environmentObject(playerModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
