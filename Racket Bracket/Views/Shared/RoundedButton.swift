//
//  RoundedButton.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

fileprivate struct RoundedButtonUX {
    static let backgroundOpacity: CGFloat = 0.3
    static let cornerRadius: CGFloat = 50
}

struct RoundedButton: View {
    let title: String
    let onTap: (() -> Void)?
    
    var content: some View {
        HStack {
            Spacer()
            
            Text(title)
                .fontWeight(.semibold)
                .padding()
                
            Spacer()
        }.background(Color.blue
            .opacity(RoundedButtonUX.backgroundOpacity)
            .cornerRadius(RoundedButtonUX.cornerRadius)
        )
    }
    
    var body: some View {
        if let onTap = onTap {
            Button {
                onTap()
            } label: {
                content
            }
        } else {
            content
        }
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(title: "button") {}
    }
}
