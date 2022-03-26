//
//  AddButton.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct AddButtonView: View {
    let config: AddButtonConfig
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button {
                onTap()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(config.backgroundColor)
                        .frame(width: AddButtonUX.height, height: AddButtonUX.height)
                        .shadow(
                            color: .black.opacity(AddButtonUX.shadowOpacity),
                            radius: AddButtonUX.shadowRadius,
                            x: 0, y: 0)
                        
                    
                    Image(systemName: config.symbol.rawValue)
                        .foregroundColor(config.symbolColor)
                        .font(.system(size: AddButtonUX.symbolFontSize, weight: .bold, design: .rounded))
                }
            }
            
            if let title = config.title {
                Text(title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonView(config: .primary) {}
        
        AddButtonView(config: .primarySelected) {}
        
        AddButtonView(config: .secondary(title: "Match", symbol: .match)) {}
    }
}
