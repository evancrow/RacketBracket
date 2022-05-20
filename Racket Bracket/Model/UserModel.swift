//
//  UserModel.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import Foundation
import Combine
import Firebase

struct UserModelDefaults {
    static let codeLength = 4
}

class UserModel: DataStorable<User>, ObservableObject {
    @Published var currentUser: User? {
        didSet {
            store(data: currentUser)
        }
    }
    
    @Published var showForcedLoggedOutAlert = false
    
    var coachId: String? {
        if let currentUser = currentUser?.id {
            return String(currentUser.prefix(UserModelDefaults.codeLength))
        }
        
        return nil
    }
    
    var canWriteData: Bool {
        if let currentUser = currentUser, currentUser.type == .coach {
            return true
        }
        
        return false
    }
    
    var isCoach: Bool {
        canWriteData
    }
    
    // MARK: - Create User
    public func createUser(type: UserType) {
        self.currentUser = User(id: Self.createUserId(), type: type)
    }
    
    static func createUserId() -> String {
        let id = UUID().uuidString
        return String(id.prefix(UserModelDefaults.codeLength))
    }
    
    // MARK: - Joining
    func tryJoining(as type: UserType, id: String, completion: @escaping (Bool) -> Void) {
        let coachId = String(id.prefix(UserModelDefaults.codeLength))
        
        CloudDataModel.shared.checkIfTeamExists(with: coachId) { [self] success in
            if success {
                currentUser = User(id: id, type: type)
            }
            
            completion(success)
        }
    }
    
    // MARK: - Logging Out
    public func logOut(teamModel: TeamModel, forced: Bool = false) {
        currentUser = nil
        teamModel.clearTeam()
        
        if forced {
            showForcedLoggedOutAlert = true
        }
    }
    
    // MARK: - init
    init() {
        super.init(extensionPath: DataExtensionPaths.user)
        currentUser = retrieveData()
    }
}
