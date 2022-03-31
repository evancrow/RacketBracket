//
//  User.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import Foundation

fileprivate struct UserArchiverKeys {
    static let id = "id"
    static let userType = "userType"
}

enum UserType: String {
    case coach = "coach"
    case player = "player"
}

class User: NSObject {
    let id: String
    let type: UserType
    
    // MARK: - init
    init(id: String, type: UserType) {
        self.id = id
        self.type = type
    }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: UserArchiverKeys.id) as? String ?? ""
        self.type = UserType(rawValue: decoder.decodeObject(forKey: UserArchiverKeys.userType) as? String ?? "") ?? .coach
    }
}

// MARK: - Archiving
extension User: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: UserArchiverKeys.id)
        coder.encode(type.rawValue, forKey: UserArchiverKeys.userType)
    }
}
