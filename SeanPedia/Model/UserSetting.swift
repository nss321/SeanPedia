//
//  Profile.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

struct Profile: Codable {
    var profileImage: String
    var nickname: String
    var signupDate: String?
}

struct LikedList: Codable {
    var likedMovie: [Int]
}

struct RecentSearch: Codable {
    var keywords: [String]
}
