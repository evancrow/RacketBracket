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
        let (teamModel, rankingModel) = (createMockTeamModel(numberOfPlayers: 2), createMockRankingModel())
        let winner = teamModel.players[0]
        let loser = teamModel.players[1]
        let mockMatch = Match(winner: winner, loser: loser, matchType: .challenge, setScore: (8, 4))
        
        rankingModel.updateRanks(with: mockMatch, teamModel: teamModel)
        
        // Make sure the highest ranked player has the most points
        XCTAssertTrue(teamModel.playersRanked[0].rank.rawScore > teamModel.playersRanked[1].rank.rawScore)
    }
    
    func testRankAdjustmentAfterMultipleGames() {
        let (teamModel, rankingModel) = (createMockTeamModel(numberOfPlayers: 2), createMockRankingModel())
        let playerOne = teamModel.players[0]
        let playerTwo = teamModel.players[1]
        
        // Game 1
        rankingModel.updateRanks(
            with: Match(winner: playerOne, loser: playerTwo, matchType: .challenge, setScore: (8, 4)),
            teamModel: teamModel)
        
        // Player 1 ranked first.
        // Game 2
        rankingModel.updateRanks(
            with: Match(winner: playerTwo, loser: playerOne, matchType: .challenge, setScore: (8, 7)),
            teamModel: teamModel)
        
        // Player 1 still ranked first.
        // Game 3
        rankingModel.updateRanks(
            with: Match(winner: playerTwo, loser: playerOne, matchType: .challenge, setScore: (5, 9)),
            teamModel: teamModel)
        
        // Player 2 should end up ranked first.
        XCTAssertTrue(playerTwo.rank.value == 1)
    }
    
    func testLargeSimulatedGame() {
        let (teamModel, rankingModel) = (createMockTeamModel(numberOfPlayers: 2), createMockRankingModel())
        
        // Play 200 games
        for _ in 1...200 {
            teamModel.players.shuffle()
            
            let firstPlayer = getRandomPlayer(teamModel: teamModel)
            let secondPlayer = getRandomPlayer(teamModel: teamModel, excluding: [firstPlayer])
            
            let firstPlayerSetsWon = Int.random(in: 2...8)
            let secondPlayerSetsWon = Int.random(in: 2...8)
            
            if firstPlayerSetsWon != secondPlayerSetsWon {
                let winner: Player = firstPlayerSetsWon > secondPlayerSetsWon ? firstPlayer : secondPlayer
                let loser: Player = firstPlayerSetsWon < secondPlayerSetsWon ? firstPlayer : secondPlayer
                
                rankingModel.updateRanks(
                    with: Match(
                        winner: winner,
                        loser: loser,
                        matchType: .challenge, setScore: (firstPlayerSetsWon, secondPlayerSetsWon)),
                    teamModel: teamModel)
            }
        }
        
        for (index, player) in teamModel.playersRanked.enumerated() {
            XCTAssertTrue(player.rank.value == index + 1)
        }
    }
    
    func testPlayersWithNoGamesArentRanked() {
        let (teamModel, rankingModel) = (createMockTeamModel(numberOfPlayers: 4), createMockRankingModel())
        let firstPlayer = teamModel.players[0]
        let secondPlayer = teamModel.players[1]
        let thirdPlayer = teamModel.players[2]
        let fourthPlayer = teamModel.players[3]
        
        // Create a match between player one and two.
        rankingModel.updateRanks(
            with: Match(winner: firstPlayer, loser: secondPlayer, matchType: .challenge, setScore: (8, 4)),
            teamModel: teamModel)
        
        // Confirm only first two players have ranks.
        XCTAssertEqual(thirdPlayer.rank.value, 0)
        XCTAssertEqual(fourthPlayer.rank.value, 0)
    }
}
