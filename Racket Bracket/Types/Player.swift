//
//  Player.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import SwiftUI

fileprivate struct PlayerArchiverKeys {
    static let name = "name"
    static let rank = "rank"
    static let matches = "match"
}

class Player: NSObject, Identifiable, ObservableObject {
    // MARK: - Properties
    internal let id = UUID()
    
    var name: String
    @ObservedObject var rank: Rank
    var matches: [Match]
    
    var matchesWon: [Match] {
        matches.filter { $0.winner == self }
    }
    
    var matchesLost: [Match] {
        matches.filter { $0.loser == self }
    }
    
    // MARK: - init
    init(name: String, rank: Rank, matches: [Match]) {
        self.name = name
        self.rank = rank
        self.matches = matches
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: PlayerArchiverKeys.name) as? String ?? ""
        self.matches = decoder.decodeObject(forKey: PlayerArchiverKeys.matches) as? [Match] ?? []
        self.rank = decoder.decodeObject(forKey: PlayerArchiverKeys.rank) as? Rank ?? Rank(value: 0, rawScore: 0)
    }
}

// MARK: - Mock Players
extension Player {
    static func mockPlayer() -> Player {
        return Player(
            name: String(Int.random(in: 1...1000000000)),
            rank: Rank(value: 0, rawScore: 0),
            matches: [])
    }
}

// MARK: - Archiving
extension Player: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PlayerArchiverKeys.name)
        coder.encode(rank, forKey: PlayerArchiverKeys.rank)
        coder.encode(matches, forKey: PlayerArchiverKeys.matches)
    }
}
