//
//  RankingModel.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import Combine

fileprivate struct RankingChangeWeights {
    static let BasePointsWonForWining = 5
    static let BasePointsLostForLosing = -5

    /// How much the points awarded/demoted are affected by difference in ranks.
    static let RankingDifference = 10
    /// How much the spread of sets won/lost affects the scoring.
    static let SetsDifference = 10
}

class RankingModel {
    public static let shared = RankingModel()

    public func updateRanks(with match: Match, teamModel: TeamModel) {
        let winner = teamModel.players.first { $0.userId == match.winnerId }
        let loser = teamModel.players.first { $0.userId == match.loserId }
        
        // Adjust the players ranks after the match.
        let winnerPoints = caluclatePoints(with: match, winner: winner, loser: loser, forWin: true)
        let loserPoints = caluclatePoints(with: match, winner: winner, loser: loser, forWin: false)
      
        winner?.rank.rawScore += winnerPoints
        winner?.matches.append(match)
        
        loser?.rank.rawScore += loserPoints
        loser?.matches.append(match)
        
        updateRanks(teamModel: teamModel)
    }
    
    private func updateRanks(teamModel: TeamModel) {
        // Update all the players ranking with the new scores.
        // The more points a player has, the higher ranked they are.
        let playersRanked = teamModel.players.sorted { $0.rank.rawScore > $1.rank.rawScore }
        for (index, player) in playersRanked.enumerated() {
            let index = index + 1
            player.rank.value = index
        }
        
        teamModel.savePlayers()
    }


    // MARK: - Calculating Points
    public func caluclatePoints(with match: Match, winner: Player?, loser: Player?, forWin: Bool) -> Int {
        let pointsForRank = calculatePointsForRank(winner: winner, loser: loser)
        let pointsForSetDifference = calculatePointsForSetDifference(setScore: match.setScore)

        if forWin {
            return RankingChangeWeights.BasePointsWonForWining + pointsForRank + pointsForSetDifference
        } else {
            return RankingChangeWeights.BasePointsLostForLosing - pointsForRank - pointsForSetDifference
        }
    }
    
    private func calculatePointsForRank(winner: Player?, loser: Player?) -> Int {
        guard let winner = winner, let loser = loser else {
            return RankingChangeWeights.RankingDifference
        }

        if winner.rank.value > loser.rank.value {
            return RankingChangeWeights.RankingDifference
        } else {
            let difference = (loser.rank.value - winner.rank.value).min(1)
            let points = difference * RankingChangeWeights.RankingDifference
            
            return points
        }
    }
    
    private func calculatePointsForSetDifference(setScore: (Int, Int)) -> Int {
        let setDifference = abs(setScore.0 - setScore.1)
        return setDifference * RankingChangeWeights.SetsDifference
    }
}
