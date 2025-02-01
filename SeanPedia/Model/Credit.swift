//
//  Credit.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

struct Credit: Decodable {
    let id: Int
    let cast: [CastInfo]
}

struct CastInfo: Decodable {
    let name: String
    let character: String
    let profile_path: String?
}

/*
 "cast": [
     {
         "adult": false,
         "gender": 2,
         "id": 23659,
         "known_for_department": "Acting",
         "name": "Will Ferrell",
         "original_name": "Will Ferrell",
         "popularity": 34.681,
         "profile_path": "/xYPM1OOLXZguj4FsgmOzTSUXaXd.jpg",
         "cast_id": 2,
         "character": "Jim",
         "credit_id": "62c6413a05b549004f3d7baf",
         "order": 0
     },
 */
