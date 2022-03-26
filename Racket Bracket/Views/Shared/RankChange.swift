//
//  RankChange.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/25/22.
//

import SwiftUI

struct RankChange: View {
    var pointsGained: Int
    
    var didWin: Bool {
        pointsGained > 0
    }

    var foregroundColor: Color {
        didWin ? .mint : .red
    }
    
    var body: some View {
        HStack {
            Image(systemName: didWin ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
            Text(String(pointsGained))
                .fontWeight(.semibold)
        }.foregroundColor(foregroundColor).font(.title2)
    }
}

struct RankChange_Previews: PreviewProvider {
    static var previews: some View {
        RankChange(pointsGained: 12)
    }
}
