//
//  NewMatchView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

struct NewMatchView: View {
    let matchType: MatchType
    
    var body: some View {
        Group {
            if matchType == .challenge {
                AddChallengeMatchView()
                    .navigationTitle("New Challenge Match")
            } else {
                AddRegularMatchView()
                    .navigationTitle("New Match")
            }
        }.background(Color(uiColor: .systemGroupedBackground))
    }
}

struct NewMatchView_Previews: PreviewProvider {
    static var previews: some View {
        NewMatchView(matchType: .challenge)
    }
}
