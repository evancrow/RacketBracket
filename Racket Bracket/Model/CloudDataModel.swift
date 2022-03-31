//
//  CloudDataModel.swift
//  Racket Bracket
//
//  Created by Evan Crow on 3/30/22.
//

import Foundation
import Firebase

protocol CloudSavable {
    var dictionaryObject: [String: Any] { get }
}

struct CloudKeys {
    static let teams = "teams"
}

class CloudDataModel {
    static let shared = CloudDataModel()
    
    private lazy var ref: DatabaseReference = {
        Database.database().reference()
    }()
    
    public func upload(object: [String: Any], underKey: String, childName: String) {
        guard !underKey.isEmpty, !childName.isEmpty else {
            return
        }
        
        self.ref.child(underKey).child(childName).setValue(object)
    }
    
    public func retrieveData(underKey: String, childName: String, completion: @escaping ([String: Any]?) -> Void) {
        guard !underKey.isEmpty, !childName.isEmpty else {
            return
        }
        
        ref.child("\(underKey)/\(childName)").getData { error, snapshot in
            guard error == nil, let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            completion(value)
        }
    }
    
    public func checkIfTeamExists(with id: String, completion: @escaping (Bool) -> Void) {
        ref.child("\(CloudKeys.teams)/\(id)").getData { error, snapshot in
            guard error == nil, snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
