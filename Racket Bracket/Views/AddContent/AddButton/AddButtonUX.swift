//
//  AddButtonUX.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import CoreGraphics

struct AddButtonUX {
    static let height: CGFloat = 44
    static let padding: CGFloat = 24
    
    static let symbolFontSize: CGFloat = 18
    
    static let shadowOpacity = 0.2
    static let shadowRadius: CGFloat = 15
}

enum AddButtonSymbol: String {
    case plus = "plus"
    case close = "xmark"
    case player = "person.fill"
    case match = "hand.wave.fill"
    case challengeMatch = "person.2.fill"
}
