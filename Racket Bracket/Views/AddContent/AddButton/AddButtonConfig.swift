//
//  AddButtonConfig.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/17/22.
//

import SwiftUI

struct AddButtonConfig {
    var backgroundColor: Color
    var symbolColor: Color
    
    var title: String?
    var symbol: AddButtonSymbol
  
    // MARK: - Defaults
    static let primary: AddButtonConfig = AddButtonConfig(
        backgroundColor: .white,
        symbolColor: .blue,
        title: nil, symbol: .plus
    )
    
    static let primarySelected: AddButtonConfig = AddButtonConfig(
        backgroundColor: .blue,
        symbolColor: .white,
        title: nil,
        symbol: .close
    )
    
    static func secondary(title: String, symbol: AddButtonSymbol) -> AddButtonConfig {
        return AddButtonConfig(
            backgroundColor: .defaultBackground,
            symbolColor: .label,
            title: title,
            symbol: symbol
        )
    }
}
