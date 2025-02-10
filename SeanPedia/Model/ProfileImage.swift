//
//  ProfileImage.swift
//  SeanPedia
//
//  Created by BAE on 1/29/25.
//

enum ProfileImage: String, CaseIterable {
    case profile0 = "profile_0"
    case profile1 = "profile_1"
    case profile2 = "profile_2"
    case profile3 = "profile_3"
    case profile4 = "profile_4"
    case profile5 = "profile_5"
    case profile6 = "profile_6"
    case profile7 = "profile_7"
    case profile8 = "profile_8"
    case profile9 = "profile_9"
    case profile10 = "profile_10"
    case profile11 = "profile_11"
    
    var profileImage: String {
        return self.rawValue
    }
    
    static func randomProfile() -> String {
        return self.allCases.randomElement()?.rawValue ?? "no image"
    }
    
    static func profileList() -> [String] {
        return self.allCases.map { $0.rawValue }
    }
}

