//
//  Error.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import Foundation

struct TMDBError: Decodable {
    let success: Bool
    let status_code: Int
    let status_message: String
}
