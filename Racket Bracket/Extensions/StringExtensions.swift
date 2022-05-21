//
//  StringExtensions.swift
//  Racket Bracket
//
//  Created by Evan Crow on 5/21/22.
//

import Foundation

extension String {
    func containsIgnoringCase(_ substring: String) -> Bool {
        self.lowercased().contains(substring.lowercased())
    }
}
