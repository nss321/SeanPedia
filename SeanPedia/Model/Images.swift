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
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.filePath = (try? container.decode(String.self, forKey: .filePath)) ?? ""
    }
}

struct PosterImage: Decodable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        filePath = (try? container.decode(String.self, forKey: .filePath)) ?? ""
    }
}
