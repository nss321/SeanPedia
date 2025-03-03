//
//  MainViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/11/25.
//

import RxSwift
import RxCocoa

final class MainViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    var recentSearchKeywords: [String] {
        if let keywordList = output.keyword.value {
            return keywordList
        }
        return []
    }
    
    struct Input {
        let keyword: CustomObservable<String?> = .init(nil)
        let profile: CustomObservable<Profile?> = .init(nil)
    }
    
    struct Output {
        let todayMovie: CustomObservable<[MovieInfo]?> = .init(nil)
        let keyword: CustomObservable<[String]?> = .init(nil)
        let profile: CustomObservable<Profile?> = .init(nil)
    }
    
    let todayMovieList2 =  BehaviorRelay<[MovieInfo]>(value: [])
    let recentSearched = BehaviorRelay<[String]>(value: UserDefaultsManager.shared.recentSearchedKeywordList2)
    
    let input: Input
    let output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
        fetchTodayMovieList()
        fetchKeywords()
        print(#function, "MainViewModel init")
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
    
    func transform2(input: Input) -> Output {
        
        return Output()
    }
    
    private func fetchTodayMovieList() {
        NetworkService.shared.callMovieRequestWithSingle(api: .trending, type: TodayMovie.self)
            .asObservable()
            .bind(with: self) { owner, response in
                switch response {
                case .success(let result):
                    owner.todayMovieList2.accept(result.results)
                case .failure(let error):
                    dump(error)
                }
            }
            .disposed(by: disposeBag)
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
        let newValue = recentSearchKeywords
        UserDefaultsManager.shared.recentSearchedKeywordList2 = newValue
    }
}
