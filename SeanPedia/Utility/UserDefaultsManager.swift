//
//  UserDefaultsManager.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() { }
    
    private let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case isOnboarded, nickname, birthday, level
    }
    
    var isOnboarded: Bool {
        get {
            return userDefaults.bool(forKey: Key.isOnboarded.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.isOnboarded.rawValue)
        }
    }
    
    func getProfile<T: Decodable>(kind: Key, type: T.Type) -> T? {
        if let storedData = userDefaults.object(forKey: kind.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let storedObject = try? decoder.decode(T.self, from: storedData) {
                return storedObject
            } else {
                print(#function, "failed to decode")
                return nil
            }
        } else {
            print(#function, "failed to unwrapping object from userdefaults")
            return nil
        }
    }
    
    func setProfile<T: Codable>(kind: Key, type: T.Type, data: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.set(encoded, forKey: kind.rawValue)
        } else {
            print(#function, "failed to save nickname to UserDefaults ")
        }
    }
    
    func resetProfile() {
        print(#function)
        userDefaults.removeObject(forKey: Key.nickname.rawValue)
        userDefaults.removeObject(forKey: Key.birthday.rawValue)
        userDefaults.removeObject(forKey: Key.level.rawValue)
    }
}
