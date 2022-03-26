//
//  Rank.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import Foundation

fileprivate struct RankArchiverKeys {
    static let value = "value"
    static let rawScore = "rawScore"
}

class Rank: NSObject, ObservableObject {
    /// The rank out of all the other players (1st for example).
    @Published var value: Int
    /// The number of points assigned to them by the algorithim.
    var rawScore: Int {
        didSet {
            rawScore = rawScore.min(0)
        }
    }
    
    // MARK: - init
    init(value: Int, rawScore: Int) {
        self.value = value
        self.rawScore = rawScore
    }
    
    required init(coder: NSCoder) {
        self.value = coder.decodeInteger(forKey: RankArchiverKeys.value)
        self.rawScore = coder.decodeInteger(forKey: RankArchiverKeys.rawScore)
    }
}

extension Rank: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(value, forKey: RankArchiverKeys.value)
        coder.encode(rawScore, forKey: RankArchiverKeys.rawScore)
    }
}
