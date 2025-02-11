//
//  SearchViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    var completion: ((String) -> Void)?
    var keyword: String = ""
    var searchedResult: [MovieInfo] = [] {
        didSet {
            searchView.searchedMovieCollectionView.reloadData()
        }
    }
    private var page = 1
    private var totalPages = 0
    private var totalResults = 0
    private var currentIndex: Int {
        searchedResult.count
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.searchBar.becomeFirstResponder()
        
        if !keyword.isEmpty {
            searchView.searchBar.text = keyword
            NetworkService.shared.callPhotoRequest(api: .search(query: keyword), type: Search.self) { Search in
                self.searchedResult = Search.results
                self.page = Search.page
                self.totalPages = Search.total_pages
                self.totalResults = Search.total_results
            } failureHandler: { TMDBError in
                dump(TMDBError)
            }
        }
    }

    override func configNavigation() {
        navigationItem.title = "영화 검색"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }),
            menu: nil)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func configDelegate() {
        searchView.searchBar.delegate = self
        searchView.searchedMovieCollectionView.delegate = self
        searchView.searchedMovieCollectionView.dataSource = self
        searchView.searchedMovieCollectionView.prefetchDataSource = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            print(#function, item)
            if currentIndex - 3 == item.item && page < totalPages {
                page += 1
                NetworkService.shared.callPhotoRequest(api: .search(query: keyword, page: page), type: Search.self, completion: { Search in
                    dump(Search.results)
                    self.searchedResult.append(contentsOf: Search.results)
                }, failureHandler: {
                    dump($0)
                })
            }
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if keyword == searchBar.text! { return }
        keyword = searchBar.text!
        completion!(keyword)
        NetworkService.shared.callPhotoRequest(api: .search(query: keyword), type: Search.self) { Search in
            if Search.results.isEmpty {
                self.searchView.noResult.isHidden = false
                self.searchView.searchedMovieCollectionView.isHidden = true
            } else {
                self.searchView.noResult.isHidden = true
                self.searchView.searchedMovieCollectionView.isHidden = false
                self.searchedResult = Search.results
                self.page = Search.page
                self.totalPages = Search.total_pages
                self.totalResults = Search.total_results
            }
        } failureHandler: { TMDBError in
            dump(TMDBError)
        }
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = searchedResult[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedMovieCollectionViewCell.id, for: indexPath) as! SearchedMovieCollectionViewCell
        cell.config(item: item)
        if item == searchedResult.last {
            cell.lastCell()
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        vc.selectedMovie = searchedResult[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
