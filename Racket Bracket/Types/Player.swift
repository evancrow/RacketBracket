//
//  Player.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import SwiftUI

fileprivate struct PlayerArchiverKeys {
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let rank = "rank"
    static let matches = "match"
}

class Player: NSObject, Identifiable, ObservableObject {
    // MARK: - Properties
    internal let id = UUID()
    
    @Published var firstName: String
    @Published var lastName: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    @ObservedObject var rank: Rank
    @Published var matches: [Match]
    
    var matchesWon: [Match] {
        matches.filter { $0.winner == self }
    }
    
    var matchesLost: [Match] {
        matches.filter { $0.loser == self }
    }
    
    // MARK: - init
    init(firstName: String, lastName: String, rank: Rank, matches: [Match]) {
        self.firstName = firstName
        self.lastName = lastName
        self.rank = rank
        self.matches = matches
    }
    
    required init(coder decoder: NSCoder) {
        self.firstName = decoder.decodeObject(forKey: PlayerArchiverKeys.firstName) as? String ?? ""
        self.lastName = decoder.decodeObject(forKey: PlayerArchiverKeys.lastName) as? String ?? ""
        self.matches = decoder.decodeObject(forKey: PlayerArchiverKeys.matches) as? [Match] ?? []
        self.rank = decoder.decodeObject(forKey: PlayerArchiverKeys.rank) as? Rank ?? Rank(value: 0, rawScore: 0)
    }
}

// MARK: - Mock Players
extension Player {
    static func mockPlayer(addMatch: Bool = true) -> Player {
        let player = Player(
            firstName: String(Int.random(in: 1...100)),
            lastName: String(Int.random(in: 1...10000)),
            rank: Rank(value: 0, rawScore: 0),
            matches: [])
        
        if addMatch {
            player.matches.append(Match.mockRegularMatch(winner: player))
            player.matches.append(Match.mockChallengeMatch(winner: player))
            player.matches.append(Match.mockRegularMatch(loser: player))
            player.matches.append(Match.mockChallengeMatch(winner: player))
            player.matches.append(Match.mockChallengeMatch(loser: player))
            player.matches.append(Match.mockRegularMatch(winner: player))
        }
        
        return player
    }
}

// MARK: - Archiving
extension Player: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(firstName, forKey: PlayerArchiverKeys.firstName)
        coder.encode(lastName, forKey: PlayerArchiverKeys.lastName)
        coder.encode(rank, forKey: PlayerArchiverKeys.rank)
        coder.encode(matches, forKey: PlayerArchiverKeys.matches)
    }
}
