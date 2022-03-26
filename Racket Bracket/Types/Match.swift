//
//  Match.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import Foundation

fileprivate struct MatchArchiverKeys {
    static let date = "date"
    static let winner = "winner"
    static let loser = "loser"
    static let matchType = "matchType"
    static let setScoreWinner = "setScoreWinner"
    static let setScoreLoser = "setScoreLoser"
}

enum MatchType: String {
    case challenge = "challenge"
    case regular = "regular"
}

class Match: NSObject, Identifiable {
    internal let id = UUID()
    
    let date: Date
    let winner: Player?
    let loser: Player?
    let matchType: MatchType

    /// The score for sets i.e. (6, 4).
    /// Highest number wins.
    let setScore: (Int, Int)
    
    // MARK: - init
    init(
        date: Date = Date(),
        winner: Player?,
        loser: Player?,
        matchType: MatchType,
        setScore: (Int, Int)
    ) {
        self.date = date
        self.winner = winner
        self.loser = loser
        self.matchType = matchType
        self.setScore = setScore
    }
    
    required init(coder decoder: NSCoder) {
        self.date = decoder.decodeObject(forKey: MatchArchiverKeys.date) as? Date ?? Date()
        self.winner = decoder.decodeObject(forKey: MatchArchiverKeys.winner) as? Player
        self.loser = decoder.decodeObject(forKey: MatchArchiverKeys.loser) as? Player
        
        let matchType = decoder.decodeObject(forKey: MatchArchiverKeys.matchType) as? String ?? ""
        self.matchType = MatchType(rawValue: matchType) ?? .regular
        
        let setScoreWinner = decoder.decodeInteger(forKey: MatchArchiverKeys.setScoreWinner)
        let setScoreLoser = decoder.decodeInteger(forKey: MatchArchiverKeys.setScoreLoser)
        self.setScore = (setScoreWinner, setScoreLoser)
    }
}

extension Match: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: MatchArchiverKeys.date)
        coder.encode(winner, forKey: MatchArchiverKeys.winner)
        coder.encode(loser, forKey: MatchArchiverKeys.loser)
        coder.encode(matchType.rawValue, forKey: MatchArchiverKeys.matchType)
        coder.encode(setScore.0, forKey: MatchArchiverKeys.setScoreWinner)
        coder.encode(setScore.1, forKey: MatchArchiverKeys.setScoreLoser)
    }
}

// MARK: - Mock Matches
extension Match {
    static func mockChallengeMatch(winner: Player? = nil, loser: Player? = nil) -> Match {
        return Match(
            winner: winner ?? Player.mockPlayer(addMatch: false),
            loser: loser ?? Player.mockPlayer(addMatch: false),
            matchType: .challenge,
            setScore: (8, 6))
    }
    
    static func mockRegularMatch(winner: Player? = nil, loser: Player? = nil) -> Match {
        return Match(
            winner: winner ?? Player.mockPlayer(addMatch: false),
            loser: loser ?? Player.mockPlayer(addMatch: false),
            matchType: .regular,
            setScore: (8, 6))
    }
}
