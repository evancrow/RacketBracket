//
//  DataTests.swift
//  Racket BracketTests
//
//  Created by Evan Crow on 3/31/22.
//

import XCTest
@testable import Racket_Bracket

class DataTests: BaseTest {
    func testPlayerFromDictionaryObject() {
        let teamModel = createMockTeamModel()
        let player = teamModel.players[0]
       
        // Confirm the same player can be created from the dictionary.
        let data = player.dictionaryObject
        let playerFromDictionary = Player(data: data)
        
        XCTAssertEqual(playerFromDictionary.userId, player.userId)
        XCTAssertEqual(playerFromDictionary.fullName, player.fullName)
        XCTAssertEqual(playerFromDictionary.rank.value, player.rank.value)
        XCTAssertEqual(playerFromDictionary.rank.rawScore, player.rank.rawScore)
        XCTAssertEqual(playerFromDictionary.matches.count, player.matches.count)
    }
    
    func testMatchFromDictionaryObject() {
        let teamModel = createMockTeamModel()
        let player = teamModel.players[0]
        let match = player.matches[0]
       
        // Confirm the same match can be created from the dictionary.
        let data = match.dictionaryObject
        let matchFromDictionary = Match(data: data)
        
        XCTAssertEqual(
            matchFromDictionary.date.formatted(date: .abbreviated, time: .omitted),
            match.date.formatted(date: .abbreviated, time: .omitted))
        XCTAssertEqual(matchFromDictionary.matchType.rawValue, match.matchType.rawValue)
        XCTAssertEqual(matchFromDictionary.winnerId, match.winnerId)
        XCTAssertEqual(matchFromDictionary.loserId, match.loserId)
        XCTAssertEqual(matchFromDictionary.setScore.0, match.setScore.0)
        XCTAssertEqual(matchFromDictionary.setScore.1, match.setScore.1)
    }
}
