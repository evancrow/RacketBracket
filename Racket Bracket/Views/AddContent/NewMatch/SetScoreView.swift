//
//  SetScoreView.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/19/22.
//

import SwiftUI

struct SetScoreView: View {
    private let buttonPadding: CGFloat = 2
    
    @Binding var winnerPoints: String
    @FocusState var editingWinnerPoints: Bool
    
    @Binding var loserPoints: String
    @FocusState var editingLoserPoints: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Set Score")
                .fontWeight(.semibold)
                .font(.title2)
            
            HStack {
                if !editingLoserPoints {
                    RoundedTextField(
                        placeholder: "Winner",
                        useNumberPad: true,
                        textFieldValue: $winnerPoints
                    ).focused($editingWinnerPoints)
                } else {
                    RoundedButton(title: "Save") {
                        editingLoserPoints = false
                    }.padding(.trailing, buttonPadding)
                }
                
                Text("to")
               
                if !editingWinnerPoints {
                    RoundedTextField(
                        placeholder: "Loser",
                        useNumberPad: true,
                        textFieldValue: $loserPoints
                    ).focused($editingLoserPoints)
                } else {
                    RoundedButton(title: "Save") {
                        editingWinnerPoints = false
                    }.padding(.leading, buttonPadding)
                }
            }
        }.padding(.top)
    }
}

struct SetScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SetScoreView(winnerPoints: .constant(""), loserPoints: .constant(""))
    }
}
