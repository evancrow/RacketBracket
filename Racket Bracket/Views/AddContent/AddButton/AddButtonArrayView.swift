//
//  AddButtonArrayView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

enum AddButtonAction {
    case addChallengeMatch
    case addPlayer
    case addRegularMatch
}

struct AddButtonArrayView: View {
    @State var showingAddOptions = false
    
    var buttonTapped: (AddButtonAction) -> Void
    
    var buttons: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 18) {
                Spacer()
                
                if showingAddOptions {
                    AddButtonView(config: .secondary(
                        title: "Match",
                        symbol: .regularMatch)
                    ) {
                        buttonTapped(.addRegularMatch)
                    }
                    
                    AddButtonView(config: .secondary(
                        title: "Challenge Match",
                        symbol: .challengeMatch)
                    ) {
                        buttonTapped(.addChallengeMatch)
                    }
                    
                    AddButtonView(config: .secondary(
                        title: "Player",
                        symbol: .newPlayer)
                    ) {
                        buttonTapped(.addPlayer)
                    }
                }
                
                AddButtonView(config: !showingAddOptions ? .primary : .primarySelected) {
                   setShowAddOptions(to: !showingAddOptions)
                }
            }
        }
        .padding(AddButtonUX.padding)
        .transition(.opacity)
    }
    
    var body: some View {
        Group {
            if showingAddOptions {
                buttons.background(
                    Material.ultraThin
                )
            } else {
                buttons
            }
        }.transition(.scale)
    }
    
    private func setShowAddOptions(to state: Bool) {
        withAnimation {
            showingAddOptions = state
        }
    }
    
    private func buttonTapped(action: AddButtonAction) {
        setShowAddOptions(to: false)
        buttonTapped(action)
    }
}

struct AddButtonArrayView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonArrayView() { _ in }
    }
}
