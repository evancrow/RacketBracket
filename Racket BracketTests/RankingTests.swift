//
//  RankingTests.swift
//  Racket BracketTests
//
//  Created by Evan Crow on 3/16/22.
//

import XCTest
@testable import Racket_Bracket

class RankingTests: BaseTest {
    func testSingleMatchAdjustingRank() {
        let (playerModel, rankingModel) = createMockObjects(numberOfPlayers: 2)
        let winner = playerModel.players[0]
        let loser = playerModel.players[1]
        let mockMatch = Match(winner: winner, loser: loser, setScore: (8, 4))
        
        rankingModel.updateRanks(with: mockMatch, playerModel: playerModel)
        
        // Make sure the highest ranked player has the most points
        XCTAssertTrue(playerModel.playersRanked[0].rank.rawScore > playerModel.playersRanked[1].rank.rawScore)
    }
    
    func testRankAdjustmentAfterMultipleGames() {
        let (playerModel, rankingModel) = createMockObjects(numberOfPlayers: 2)
        let playerOne = playerModel.players[0]
        let playerTwo = playerModel.players[1]
        
        // Game 1
        rankingModel.updateRanks(
            with: Match(winner: playerOne, loser: playerTwo, setScore: (8, 4)), playerModel: playerModel)
        
        // Player 1 ranked first.
        // Game 2
        rankingModel.updateRanks(
            with: Match(winner: playerTwo, loser: playerOne, setScore: (8, 7)), playerModel: playerModel)
        
        // Player 1 still ranked first.
        // Game 3
        rankingModel.updateRanks(
            with: Match(winner: playerTwo, loser: playerOne, setScore: (5, 7)), playerModel: playerModel)
        
        // Player 2 should end up ranked first.
        XCTAssertTrue(playerTwo.rank.value == 1)
    }
    
    func testLargeSimulatedGame() {
        let (playerModel, rankingModel) = createMockObjects(numberOfPlayers: 10)
        
        // Play 200 games
        for _ in 1...200 {
            playerModel.players.shuffle()
            
            let firstPlayer = getRandomPlayer(playerModel: playerModel)
            let secondPlayer = getRandomPlayer(playerModel: playerModel, excluding: [firstPlayer])
            
            let firstPlayerSetsWon = Int.random(in: 2...8)
            let secondPlayerSetsWon = Int.random(in: 2...8)
            
            if firstPlayerSetsWon != secondPlayerSetsWon {
                let winner: Player = firstPlayerSetsWon > secondPlayerSetsWon ? firstPlayer : secondPlayer
                let loser: Player = firstPlayerSetsWon < secondPlayerSetsWon ? firstPlayer : secondPlayer
                
                rankingModel.updateRanks(
                    with: Match(
                        winner: winner,
                        loser: loser,
                        setScore: (firstPlayerSetsWon, secondPlayerSetsWon)),
                    playerModel: playerModel)
            }
        }
        
        for (index, player) in playerModel.playersRanked.enumerated() {
            XCTAssertTrue(player.rank.value == index + 1)
        }
    }
}
