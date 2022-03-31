//
//  DataStorable.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import Foundation

public struct DataExtensionPaths {
    static let players = "player.model.data"
    static let user = "current.user"
}

class DataStorable<DataType: Any> {
    let extensionPath: String
    
    // MARK: - Storing
    public func store(data: DataType?) {
        storeDataToStorage(try? NSKeyedArchiver.archivedData(withRootObject: [data], requiringSecureCoding: false))
    }
    
    public func store(data: [DataType]) {
        storeDataToStorage(try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false))
    }
    
    private func storeDataToStorage(_ data: Data?) {
        do {
            try data?.write(to: getFilePath())
        } catch {
            print("Couldn't write data (\(extensionPath)) with error: ", error.localizedDescription)
        }
    }

    // MARK: - Retrieving
    public func retrieveData() -> DataType? {
        guard let data = retrieveDataFromStorage(), data.count == 1 else {
            print("Data (\(extensionPath)) did not exist or there was more than one item.")
            return nil
        }
        
        return data[0]
    }
    
    public func retrieveDataAsArray() -> [DataType]? {
        return retrieveDataFromStorage()
    }
    
    private func retrieveDataFromStorage() -> [DataType]? {
        guard let data = try? Data(contentsOf: getFilePath()) else {
            return nil
        }

        do {
            if let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [DataType] {
                return unarchivedData
            }
        } catch {
            print("Couldn't read data (\(extensionPath)) with error: ", error.localizedDescription)
        }
        
        return nil
    }

    // MARK: - Helpers
    private func getFilePath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent(extensionPath)
    }
    
    // MARK: - init
    init(extensionPath: String) {
        self.extensionPath = extensionPath
    }
}
