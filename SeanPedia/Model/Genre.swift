//
//  Genre.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

enum Genre: Int {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case sf = 878
    case tvMovie = 10770
    case thriller = 53
    case war = 10752
    case western = 37

    var genreName: String {
        switch self {
        case .action: return "액션"
        case .adventure: return "모험"
        case .animation: return "애니메이션"
        case .comedy: return "코미디"
        case .crime: return "범죄"
        case .documentary: return "다큐멘터리"
        case .drama: return "드라마"
        case .family: return "가족"
        case .fantasy: return "판타지"
        case .history: return "역사"
        case .horror: return "공포"
        case .music: return "음악"
        case .mystery: return "미스터리"
        case .romance: return "로맨스"
        case .sf: return "SF"
        case .tvMovie: return "TV 영화"
        case .thriller: return "스릴러"
        case .war: return "전쟁"
        case .western: return "서부"
        }
    }
    
    static func genreId(_ id: Int) -> String {
        return Genre(rawValue: id)?.genreName ?? ""
    }
}
