//
//  Player.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import SwiftUI

fileprivate struct PlayerArchiverKeys {
    static let userId = "userId"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let rank = "rank"
    
    static let rankValue = "rank"
    static let rankRawScore = "rawScore"
    
    static let matches = "match"
}

class Player: NSObject, Identifiable, ObservableObject, CloudSavable {
    // MARK: - Properties
    public let userId: String
    
    @Published var firstName: String
    @Published var lastName: String
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    @ObservedObject var rank: Rank
    @Published var matches: [Match]
    
    var matchesWon: [Match] {
        matches.filter { $0.winnerId == self.userId }
    }
    
    var matchesLost: [Match] {
        matches.filter { $0.loserId == self.userId }
    }
    
    var dictionaryObject: [String : Any] {
        return [
            PlayerArchiverKeys.userId: userId,
            PlayerArchiverKeys.firstName: firstName,
            PlayerArchiverKeys.lastName: lastName,
            PlayerArchiverKeys.rank: [PlayerArchiverKeys.rankValue: rank.value, PlayerArchiverKeys.rankRawScore: rank.rawScore],
            PlayerArchiverKeys.matches: matches.map { $0.dictionaryObject }
        ]
    }
    
    // MARK: - init
    init(userId: String, firstName: String, lastName: String, rank: Rank, matches: [Match]) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.rank = rank
        self.matches = matches
    }
    
    init(data: [String: Any]) {
        let userId = data[PlayerArchiverKeys.userId] as? String ?? ""
        let firstName = data[PlayerArchiverKeys.firstName] as? String ?? ""
        let lastName = data[PlayerArchiverKeys.lastName] as? String ?? ""
        
        let rank = data[PlayerArchiverKeys.rank] as? [String: Any] ?? [:]
        let rankValue = rank[PlayerArchiverKeys.rankValue] as? Int ?? 0
        let rankRawScore = rank[PlayerArchiverKeys.rankRawScore] as? Int ?? 0
        
        let matchesData = data[PlayerArchiverKeys.matches] as? [[String: Any]] ?? []
        let matches = matchesData.map {
            Match(data: $0)
        }
        
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.rank = Rank(value: rankValue, rawScore: rankRawScore)
        self.matches = matches
    }
    
    required init(coder decoder: NSCoder) {
        self.userId = decoder.decodeObject(forKey: PlayerArchiverKeys.userId) as? String ?? ""
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
            userId: UUID().uuidString,
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
        coder.encode(userId, forKey: PlayerArchiverKeys.userId)
        coder.encode(firstName, forKey: PlayerArchiverKeys.firstName)
        coder.encode(lastName, forKey: PlayerArchiverKeys.lastName)
        coder.encode(rank, forKey: PlayerArchiverKeys.rank)
        coder.encode(matches, forKey: PlayerArchiverKeys.matches)
    }
}
