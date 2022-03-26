//
//  Racket_BracketTests.swift
//  Racket BracketTests
//
//  Created by Evan Crow on 3/16/22.
//

import XCTest
@testable import Racket_Bracket

class BaseTest: XCTestCase {
    func createMockObjects(numberOfPlayers: Int = 5) -> (PlayerModel, RankingModel) {
        let mockPlayers: [Player] = {
            var players = [Player]()
            for _ in 1...numberOfPlayers {
                players.append(Player.mockPlayer())
            }
            
            return players
        }()
        
        let playerModel = PlayerModel()
        playerModel.players = mockPlayers
        
        let rankingModel = RankingModel()
        
        return (playerModel, rankingModel)
    }
    
    func getRandomPlayer(playerModel: PlayerModel, excluding: [Player] = []) -> Player {
        while true {
            let randomIndex = Int.random(in: 0...(playerModel.players.count - 1))
            let randomPlayer = playerModel.players[randomIndex]
            
            if !excluding.contains(randomPlayer) {
                return randomPlayer
            }
        }
    }
    
    func printPlayerRankingStates(with playerModel: PlayerModel) {
        print("\n")
        
        let rankings = playerModel.playersRanked
        for player in rankings {
            print("Name:", player.name, "Rank:", player.rank.value, "Raw Score:", player.rank.rawScore)
        }
        
        print("\n")
    }
}
