//
//  IntExtensions.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import Foundation

extension Int {
    /// Makes sure that `self` is not below `min`,
    /// and will change `self` to `min` if it happens to be below.
    func min(_ min: Int) -> Int {
        var value = self
        if value < min {
            value = min
        }
        
        return value
    }
    
    /// Makes sure that `self` isn't exceeding `max`,
    /// and will change `self` to `max` if it happens to be above.
    func max(_ max: Int) -> Int {
        var value = self
        if value > max {
            value = max
        }
        
        return value
    }
}
