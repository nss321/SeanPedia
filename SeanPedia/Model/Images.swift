//
//  Images.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

import Foundation

struct Images: Decodable {
    let backdrops: [BackdropImage]
    let posters: [PosterImage]
}

struct BackdropImage: Decodable {
    let file_path: String
}

struct PosterImage: Decodable {
    let file_path: String
}
