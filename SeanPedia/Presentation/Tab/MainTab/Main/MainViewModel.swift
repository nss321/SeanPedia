//
//  MainViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/11/25.
//

final class MainViewModel: BaseViewModel {
    
    var todayMovieList: [MovieInfo] {
        if let movieList = output.todayMovie.value {
            return movieList
        }
        return []
    }
    
    var recentSearchKeywords: [String] {
        if let keywordList = output.keyword.value {
            return keywordList
        }
        return []
    }
    
    struct Input {
        let keyword: Observable<String?> = .init(nil)
        let profile: Observable<Profile?> = .init(nil)
    }
    
    struct Output {
        let todayMovie: Observable<[MovieInfo]?> = .init(nil)
        let keyword: Observable<[String]?> = .init(nil)
        let profile: Observable<Profile?> = .init(nil)
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
        input.keyword.bind { [weak self] keyword in
            if let keyword {
                self?.output.keyword.value?.append(keyword)
            } else {
                print(#function, "failed to unwrapping keyword. keyword didn't append to collectionview")
                return
            }
        }
        input.profile.bind { [weak self] profile in
            self?.output.profile.value = profile
        }
    }
    
    private func fetchTodayMovieList() {
        NetworkService.shared.callPhotoRequest(
            api: .trending,
            type: TodayMovie.self) { [weak self] response in
//                dump(response)
                self?.output.todayMovie.value = response.results
            } failureHandler: { _ in
            }
    }
    
    private func fetchKeywords() {
        output.keyword.value = UserDefaultsManager.shared.recentSearchedKeywordList.keywords
    }
    
    func popKeyword(index: Int) {
        if let keyword = output.keyword.value {
            if (0...keyword.count).contains(index) {
                output.keyword.value?.remove(at: index)
            }
        }
    }
    
    func removeAllofKeyword() {
        output.keyword.value?.removeAll()
    }
    
    func saveRecentSearch() {
        let newValue = RecentSearch(keywords: recentSearchKeywords)
        UserDefaultsManager.shared.setData(kind: .recentlyKeyword, type: RecentSearch.self, data: newValue)
    }
}
