//
//  SignInView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import SwiftUI

struct SignInView: View {
    @State var showCoachOptions = false
    @State var showJoinTeamView = false
    @State var showNewTeamView = false
    
    var title: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to Racket Bracket")
                .font(.largeTitle)
                .bold()
            
            Text("Select one of the options below\nto get started.")
        }
    }
    
    var buttons: some View {
        VStack {
            if showCoachOptions {
                RoundedButton(title: "I already have a team") {
                    showJoinTeamView = true
                }
                
                RoundedButton(title: "New team") {
                    showNewTeamView = true
                }
                
                RoundedButton(title: "back") {
                    withAnimation {
                        showCoachOptions = false
                    }
                }
            } else {
                RoundedButton(title: "I'm a Coach") {
                    withAnimation {
                        showCoachOptions = true
                    }
                }
                
                RoundedButton(title: "I'm a Player") {
                    showJoinTeamView = true
                }
            }
            
            NavigationLink(isActive: $showJoinTeamView) {
                JoinTeamView(type: showCoachOptions ? .coach : .player)
            } label: { EmptyView() }
            
            NavigationLink(isActive: $showNewTeamView) {
                NewTeamView()
            } label: { EmptyView() }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 42) {
               title
               buttons
            }
            .padding()
            .navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
        SignInView(showCoachOptions: true)
    }
}
