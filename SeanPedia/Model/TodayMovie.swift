//
//  TodayMovie.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import Foundation

struct TodayMovie: Decodable {
    let page: Int
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    let id: Int
    let poster_path: String
    let title: String
    let overview: String
    let vote_average: Double
    let genre_ids: [Int]
    let release_date: String
}

/*
 1. 포스터
 2. 영화 이름
 3. 줄거리
 4. 좋아요
 */
