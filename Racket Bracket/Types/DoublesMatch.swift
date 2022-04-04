//
//  DoublesMatch.swift
//  Racket Bracket
//
//  Created by Evan Crow on 4/4/22.
//

import Foundation

fileprivate struct DoublesMatchArchiverKeys {
    static let partner = "partner"
}

class DoublesMatch: Match {
    let partnerId: String
    
    override var dictionaryObject: [String : Any] {
        var dictionary = super.dictionaryObject
        dictionary[DoublesMatchArchiverKeys.partner] = partnerId
        
        return dictionary
    }
    
    override func playerDidWin(_ player: Player) -> Bool {
        winnerId != nil
    }
    
    // MARK: - init
    init(
        date: Date = Date(),
        winner: Player?,
        loser: Player?,
        partner: Player,
        setScore: (Int, Int)
    ) {
        self.partnerId = partner.userId
        
        super.init(
            date: date,
            winner: winner,
            loser: loser,
            matchType: .doubles,
            setScore: setScore)
    }
    
    required init(coder decoder: NSCoder) {
        self.partnerId = decoder.decodeObject(forKey: DoublesMatchArchiverKeys.partner) as? String ?? ""
        super.init(coder: decoder)
    }
    
    override init(data: [String: Any]) {
        let partnerId = data[DoublesMatchArchiverKeys.partner] as? String ?? ""
        self.partnerId = partnerId
        
        super.init(data: data)
    }
}

extension DoublesMatch {
    override func encode(with coder: NSCoder) {
        coder.encode(partnerId, forKey: DoublesMatchArchiverKeys.partner)
        super.encode(with: coder)
    }
}
