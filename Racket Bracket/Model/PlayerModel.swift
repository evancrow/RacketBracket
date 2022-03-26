//
//  PlayerModel.swift
//  Racquet Bracket (iOS)
//
//  Created by Evan Crow on 3/16/22.
//

import Foundation
import Combine

class PlayerModel: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var players: [Player] = [] {
        didSet {
            savePlayers()
        }
    }

    var playersRanked: [Player] {
        players.sorted { $0.rank.value < $1.rank.value }
    }

    // MARK: - Public Methods
    public func getPlayers(filteringName: String? = nil, excluding: [Player?] = []) -> [Player] {
        let filteredPlayers = playersRanked.filter { !excluding.contains($0) }
        
        if let filteringName = filteringName, !filteringName.isEmpty {
            return filteredPlayers.filter { $0.name.contains(filteringName) }
        }
        
        return filteredPlayers
    }

    public func addPlayer(with name: String) {
        players.append(Player(name: name, rank: Rank(value: 0, rawScore: 0), matches: []))
    }

    // MARK: - Data Storage
    public func savePlayers() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: players, requiringSecureCoding: false)
            try data.write(to: getFilePath())
        } catch {
            print("Couldn't write file with error: ", error.localizedDescription)
        }
    }

    private func retrieveAndSetPlayers() {
        guard let data = try? Data(contentsOf: getFilePath()) else {
            return
        }

        do {
            if let players = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Player] {
                self.players = players
            }
        } catch {
            print("Couldn't read file with error: ", error.localizedDescription)
        }
    }

    private func getFilePath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("player.model.data")
    }

    init(addMockPlayers: Bool = false) {
        super.init()
        
        if addMockPlayers {
            for _ in 0...20 {
                players.append(Player.mockPlayer())
            }
        } else {
            self.retrieveAndSetPlayers()
        }
    }
}
