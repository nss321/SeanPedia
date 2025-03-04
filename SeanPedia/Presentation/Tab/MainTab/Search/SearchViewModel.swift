//
//  SearchViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/12/25.
//

import Foundation

final class SearchViewModel: BaseViewModel {
    
    var completion: ((String) -> Void)?
    var keyword: String = ""
    var searchedResult: [MovieInfo] {
        if let searchedResult = output.searchedResult.value {
            return searchedResult
        }
        return []
    }
    private var page = 1
    private var totalPages = 0
    private var totalResults = 0
    private var currentIndex: Int {
        searchedResult.count
    }
    
    struct Input {
        let givenKeyword: CustomObservable<String?> = .init(nil)
        let searchedResult: CustomObservable<[MovieInfo]?> = .init(nil)
        let typedKeyword: CustomObservable<String?> = .init(nil)
    }
    
    struct Output {
        let searchedResult: CustomObservable<[MovieInfo]?> = .init(nil)
        let isEmptyResult = CustomObservable(false)
    }
    
    let input: Input
    let output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.searchedResult.bind { [weak self] movieList in
            self?.output.searchedResult.value = movieList
        }
        input.givenKeyword.bind { [weak self] keyword in
            if let keyword {
                self?.fetchSearchResult(keyword: keyword)
            } else {
                print(#function, "failed to unwrapping keyword. search result didn't fetched.")
            }
        }
        input.typedKeyword.bind { [weak self] keyword in
            print(#function, "키워드 검색")
            if let keyword {
                self?.callSearchRequest(keyword: keyword)
            } else {
                print(#function, "failed to unwrapping keyword. search result didn't fetched.")
            }
        }
    }
    
    private func fetchSearchResult(keyword: String) {
        NetworkService.shared.callMovieRequest(api: .search(query: keyword), type: Search.self) { [weak self] Search in
            self?.input.searchedResult.value = Search.results
            self?.page = Search.page
            self?.totalPages = Search.total_pages
            self?.totalResults = Search.total_results
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }
    }
    
    func prefetchItems(indexPath: IndexPath) {
        if currentIndex - 3 == indexPath.item && page < totalPages {
            page += 1
            NetworkService.shared.callMovieRequest(api: .search(query: keyword, page: page), type: Search.self, completion: { [weak self] Search in
                dump(Search.results)
                self?.output.searchedResult.value?.append(contentsOf: Search.results)
            }, failureHandler: {
                dump($0)
            })
        }
    }
    
    private func callSearchRequest(keyword: String) {
        NetworkService.shared.callMovieRequest(api: .search(query: keyword), type: Search.self) { [weak self] Search in
//            print(#function, Search)
            if Search.results.isEmpty {
                self?.output.isEmptyResult.value = true
            } else {
                self?.output.isEmptyResult.value = false
                self?.input.searchedResult.value = Search.results
                self?.page = Search.page
                self?.totalPages = Search.total_pages
                self?.totalResults = Search.total_results
            }
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }
    }
}
