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

class Match: NSObject, Identifiable, CloudSavable {
    internal let id = UUID()
    private let dateFormat = "yyyy-MM-dd"
    
    let date: Date
    let winnerId: String?
    let loserId: String?
    let matchType: MatchType

    /// The score for sets i.e. (6, 4).
    /// Highest number wins.
    let setScore: (Int, Int)
    
    var dictionaryObject: [String : Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return [
            MatchArchiverKeys.date: dateFormatter.string(from: date),
            MatchArchiverKeys.winner: winnerId as Any,
            MatchArchiverKeys.loser: loserId as Any,
            MatchArchiverKeys.matchType: matchType.rawValue,
            MatchArchiverKeys.setScoreWinner: setScore.0,
            MatchArchiverKeys.setScoreLoser: setScore.1
        ]
    }
    
    // MARK: - init
    init(
        date: Date = Date(),
        winner: Player?,
        loser: Player?,
        matchType: MatchType,
        setScore: (Int, Int)
    ) {
        self.date = date
        self.winnerId = winner?.userId
        self.loserId = loser?.userId
        self.matchType = matchType
        self.setScore = setScore
    }
    
    required init(coder decoder: NSCoder) {
        self.date = decoder.decodeObject(forKey: MatchArchiverKeys.date) as? Date ?? Date()
        self.winnerId = decoder.decodeObject(forKey: MatchArchiverKeys.winner) as? String
        self.loserId = decoder.decodeObject(forKey: MatchArchiverKeys.loser) as? String
        
        let matchType = decoder.decodeObject(forKey: MatchArchiverKeys.matchType) as? String ?? ""
        self.matchType = MatchType(rawValue: matchType) ?? .regular
        
        let setScoreWinner = decoder.decodeInteger(forKey: MatchArchiverKeys.setScoreWinner)
        let setScoreLoser = decoder.decodeInteger(forKey: MatchArchiverKeys.setScoreLoser)
        self.setScore = (setScoreWinner, setScoreLoser)
    }
    
    init(data: [String: Any]) {
        let date = data[MatchArchiverKeys.date] as? String ?? ""
        let winnerId = data[MatchArchiverKeys.winner] as? String ?? ""
        let loserId = data[MatchArchiverKeys.loser] as? String ?? ""
        let matchType = data[MatchArchiverKeys.matchType] as? String ?? ""
        let scoreWinner = data[MatchArchiverKeys.setScoreWinner] as? Int ?? 0
        let scoreLoser = data[MatchArchiverKeys.setScoreLoser] as? Int ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        self.date = dateFormatter.date(from: date)!
        self.winnerId = winnerId
        self.loserId = loserId
        self.matchType = MatchType(rawValue: matchType) ?? .challenge
        self.setScore = (scoreWinner, scoreLoser)
    }
}

extension Match: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: MatchArchiverKeys.date)
        coder.encode(winnerId, forKey: MatchArchiverKeys.winner)
        coder.encode(loserId, forKey: MatchArchiverKeys.loser)
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
