//
//  Checkbox.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/18/22.
//

import SwiftUI

fileprivate struct CheckboxUX {
    static let borderWidth: CGFloat = 1
    static let height: CGFloat = 25
}

struct Checkbox: View {
    @Binding var selected: Bool
    var title: String? = nil
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    selected.toggle()
                }
            } label: {
                if selected {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.blue)
                            .frame(width: CheckboxUX.height, height: CheckboxUX.height)
                        
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .semibold))
                    }
                } else {
                    Circle()
                        .stroke(Color.blue)
                        .frame(width: CheckboxUX.height, height: CheckboxUX.height)
                }
            }
            
            if let title = title {
                Text(title)
                    .fontWeight(.medium)
                    .padding(.leading)
            }
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Checkbox(selected: .constant(true))
            Checkbox(selected: .constant(true), title: "Checkmark Title")
        }
    }
}
