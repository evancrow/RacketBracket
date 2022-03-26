//
//  RoundedTextField.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

fileprivate struct RoundedTextFieldUX {
    static let backgroundOpacity: CGFloat = 0.08
    static let cornerRadius: CGFloat = 12
}

struct RoundedTextField: View {
    let placeholder: String
    var useNumberPad = false
    
    @Binding var textFieldValue: String
    
    var body: some View {
        TextField(placeholder, text: $textFieldValue)
            .keyboardType(useNumberPad ? .numberPad : .default)
            .padding()
            .background(
                Color.label
                    .opacity(RoundedTextFieldUX.backgroundOpacity)
                    .cornerRadius(RoundedTextFieldUX.cornerRadius)
            )
    }
}

struct RoundedTextField_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTextField(placeholder: "Enter text", textFieldValue: .constant(""))
    }
}
