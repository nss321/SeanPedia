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
        case likedMovie, profile, recentlyKeyword, isOnboarded, mbti

    }
    
    /*
     profileImage -> String; e.g. profile_0
     nickname -> String; e.g. 션션
     signupDate -> String; e.g. 25.01.23 가입
     likedMovie -> Array; ["id"]
     무비박스 보관중~ ud.shared.likedCount()
     
     */
    
    var isOnboarded: Bool {
        get {
            return userDefaults.bool(forKey: Key.isOnboarded.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.isOnboarded.rawValue)
        }
    }
    
    var likedList: [Int] {
        get {
            if let list = userDefaults.array(forKey: Key.likedMovie.rawValue) as? [Int] {
                return list
            } else {
                return []
            }
        }
        set {
            userDefaults.set(newValue, forKey: Key.likedMovie.rawValue)
        }
    }
    
    var recentSearchedKeywordList: RecentSearch {
        get {
            if let list = getStoredData(kind: .recentlyKeyword, type: RecentSearch.self) {
                return list
            } else {
                return RecentSearch(keywords: [])
            }
        }
    }
    
    var mbti: String {
        get {
            return userDefaults.string(forKey: Key.mbti.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.mbti.rawValue)
        }
    }
    
    func getStoredData<T: Decodable>(kind: Key, type: T.Type) -> T? {
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
    
    func setData<T: Codable>(kind: Key, type: T.Type, data: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.set(encoded, forKey: kind.rawValue)
        } else {
            print(#function, "failed to save nickname to UserDefaults ")
        }
    }
    
    func resetData() {
        print(#function)
        isOnboarded = false
        userDefaults.removeObject(forKey: Key.profile.rawValue)
        userDefaults.removeObject(forKey: Key.likedMovie.rawValue)
        userDefaults.removeObject(forKey: Key.recentlyKeyword.rawValue)
    }
}
