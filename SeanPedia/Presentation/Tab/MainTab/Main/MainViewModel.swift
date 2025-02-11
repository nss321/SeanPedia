//
//  MainViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/11/25.
//

final class MainViewModel: BaseViewModel {
    
    var todayMovieList: [MovieInfo] {
        if let movieList = output.outputTodayMovie.value {
            return movieList
        }
        return []
    }
    
    var recentSearchKeywords: [String] {
        if let keywordList = output.outputKeyword.value {
            return keywordList
        }
        return []
    }
    
    struct Input {
        let inputKeyword: Observable<String?> = .init(nil)
    }
    
    struct Output {
        let outputTodayMovie: Observable<[MovieInfo]?> = .init(nil)
        let outputKeyword: Observable<[String]?> = .init(nil)
    }
    
    let input: Input
    let output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
        fetchTodayMovieList()
        fetchKeywords()
    }
    
    func transform() {
        input.inputKeyword.bind { [weak self] keyword in
            self?.output.outputKeyword.value?.append(keyword!)
        }
    }
    
    func fetchTodayMovieList() {
        NetworkService.shared.callPhotoRequest(
            api: .trending,
            type: TodayMovie.self) { [weak self] response in
//                dump(response)
                self?.output.outputTodayMovie.value = response.results
            } failureHandler: { _ in
            }
    }
    
    func fetchKeywords() {
        output.outputKeyword.value = UserDefaultsManager.shared.recentSearchedKeywordList.keywords
    }
    
    func popKeyword(index: Int) {
        if let keyword = output.outputKeyword.value {
            if (0...keyword.count).contains(index) {
                output.outputKeyword.value?.remove(at: index)
            }
        }
    }
    
    func removeAllofKeyword() {
        output.outputKeyword.value?.removeAll()
    }
    
    func saveRecentSearch() {
        let newValue = RecentSearch(keywords: recentSearchKeywords)
        UserDefaultsManager.shared.setData(kind: .recentlyKeyword, type: RecentSearch.self, data: newValue)
    }
}
