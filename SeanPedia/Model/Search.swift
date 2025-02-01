//
//  Search.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

struct Search: Decodable {
    let page: Int
    let results: [MovieInfo]
    let total_pages: Int
    let total_results: Int
}

/*
 {
     "page": 1,
     "results": [
         {
             "adult": false,
             "backdrop_path": "/vv3696up1ODTUZ6z98ySepoTijy.jpg",
             "genre_ids": [
                 10749,
                 18
             ],
             "id": 310096,
             "original_language": "zh",
             "original_title": "警花燕子",
             "overview": "갓 교통경찰이 된 연자는 실습에 나갔다가 자신을 여자라고 무시하는 변호사 서목장춘을 만나게 된다. 연자는 교통법규를 위반한 변호사 서목장춘의 자동차를 압류하고 서목장춘은 이에 화가 나 연자를 혼쭐을 내주고자 소송을 건다. 만나기만 하면 티격태격.  사랑에 서툰 두 사람의 좌충우돌 사랑이야기...",
             "popularity": 0.609,
             "poster_path": "/uPy17tTZLT5kkf5KA7DBedXgxrx.jpg",
             "release_date": "2006-03-28",
             "title": "탕웨이의 투캅스",
             "video": false,
             "vote_average": 0.0,
             "vote_count": 0
         }
     ],
     "total_pages": 1,
     "total_results": 1
 }
 
 */
