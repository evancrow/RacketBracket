//
//  TeamModel.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import Foundation
import Combine

struct PlayerDefaults {
    static let basePoints = 200
}

fileprivate struct TeamCloudKeys {
    static let teamName = "Team"
    static let players = "Players"
}

fileprivate struct UserDefaultKeys {
    static let teamName = "teamName"
}

class TeamModel: ObservableObject {
    // MARK: - Properties
    private let userModel: UserModel?
    
    @Published var teamName: String? {
        didSet {
            UserDefaults.standard.set(teamName, forKey: UserDefaultKeys.teamName)
        }
    }
    
    @Published var players: [Player] = []
    
    @Published var detailPlayer: Player? {
        didSet {
            if detailPlayer != nil {
                showPlayerDetailView = true
            }
        }
    }
    
    @Published var showPlayerDetailView = false {
        didSet {
            if !showPlayerDetailView {
                detailPlayer = nil
            }
        }
    }

    var playersRanked: [Player] {
        players.sorted { $0.rank.rawScore > $1.rank.rawScore }
    }

    // MARK: - Player Methods
    public func getPlayers(filteringName: String? = nil, excluding: [Player?] = []) -> [Player] {
        let filteredPlayers = playersRanked.filter { !excluding.contains($0) }
        
        if let filteringName = filteringName, !filteringName.isEmpty {
            return filteredPlayers.filter { $0.fullName.contains(filteringName) }
        }
        
        return filteredPlayers
    }

    public func addPlayer(with firstName: String, lastName: String) {
        players.append(Player(
            userId: "\(userModel?.coachId ?? "")-\(UserModel.createUserId())",
            firstName: firstName,
            lastName: lastName,
            rank: Rank(value: 0, rawScore: PlayerDefaults.basePoints),
            matches: [])
        )
        
        savePlayers()
    }
    
    // MARK: - Team Methods
    public func createTeam(with name: String) {
        self.teamName = name
        savePlayers()
    }
    
    /// Will erase the team from storage, for use when logging out.
    public func clearTeam() {
        self.teamName = nil
        self.players = []
    }
    
    public func deleteTeam(coachId: String) {
        CloudDataModel.shared.upload(
            object: [:],
            underKey: CloudKeys.teams,
            childName: coachId)
    }
    
    // MARK: - Data Methods
    public func savePlayers() {
        guard userModel?.canWriteDate ?? false, let coachId = userModel?.coachId, let teamName = teamName else {
            return
        }
        
        CloudDataModel.shared.upload(
            object: [
                "Team": teamName,
                "Players": players.map { $0.dictionaryObject }],
            underKey: CloudKeys.teams,
            childName: coachId)
    }
    
    public func retrieveDataFromCloud(completion: @escaping (Bool) -> Void = { _ in }) {
        guard let coachId = userModel?.coachId else {
            completion(false)
            return
        }
        
        CloudDataModel.shared.retrieveData(underKey: CloudKeys.teams, childName: coachId) { [self] data in
            guard let data = data else {
                completion(false)
                userModel?.logOut(teamModel: self, forced: true)
                
                return
            }

            let teamName = data[TeamCloudKeys.teamName] as? String
            let playerData = data[TeamCloudKeys.players] as? [[String: Any]] ?? []
            let players = playerData.map {
                Player(data: $0)
            }
            
            // Log the user out if they are a player and no longer apart of the team.
            if let userModel = userModel, let currentUser = userModel.currentUser {
                let userIds = players.map { $0.userId }
                if !userModel.canWriteDate && !userIds.contains(currentUser.id) {
                    userModel.logOut(teamModel: self, forced: true)
                }
            }
           
            self.teamName = teamName
            self.players = players
            
            completion(true)
        }
    }
    
    // MARK: - init
    init(userModel: UserModel? = nil, addMockPlayers: Bool = false) {
        self.teamName = UserDefaults.standard.string(forKey: UserDefaultKeys.teamName)
        self.userModel = userModel
        
        if addMockPlayers {
            for _ in 0...20 {
                players.append(Player.mockPlayer())
            }
        } else {
            retrieveDataFromCloud()
        }
    }
}
