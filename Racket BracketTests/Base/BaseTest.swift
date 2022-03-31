//
//  Racket_BracketTests.swift
//  Racket BracketTests
//
//  Created by Evan Crow on 3/16/22.
//

import XCTest
@testable import Racket_Bracket

class BaseTest: XCTestCase {
    func createMockObjects(numberOfPlayers: Int = 5) -> (TeamModel, RankingModel) {
        let mockPlayers: [Player] = {
            var players = [Player]()
            for _ in 1...numberOfPlayers {
                players.append(Player.mockPlayer())
            }
            
            return players
        }()
        
        let teamModel = TeamModel()
        teamModel.players = mockPlayers
        
        let rankingModel = RankingModel()
        
        return (teamModel, rankingModel)
    }
    
    func getRandomPlayer(teamModel: TeamModel, excluding: [Player] = []) -> Player {
        while true {
            let randomIndex = Int.random(in: 0...(teamModel.players.count - 1))
            let randomPlayer = teamModel.players[randomIndex]
            
            if !excluding.contains(randomPlayer) {
                return randomPlayer
            }
        }
    }
    
    func printPlayerRankingStates(with teamModel: TeamModel) {
        print("\n")
        
        let rankings = teamModel.playersRanked
        for player in rankings {
            print("Name:", player.fullName, "Rank:", player.rank.value, "Raw Score:", player.rank.rawScore)
        }
        
        print("\n")
    }
}
