//
//  SearchViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    let viewModel = SearchViewModel()

    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.searchBar.becomeFirstResponder()
        
        if !viewModel.keyword.isEmpty {
            searchView.searchBar.text = viewModel.keyword
            viewModel.input.givenKeyword.value = viewModel.keyword
        }
    }
    
    private func bind() {
        viewModel.output.searchedResult.bind { [weak self] _ in
            self?.searchView.searchedMovieCollectionView.reloadData()
        }
        viewModel.output.isEmptyResult.bind { [weak self] isEmpty in
            print(#function, isEmpty)
            if isEmpty {
                self?.searchView.noResult.isHidden = false
                self?.searchView.searchedMovieCollectionView.isHidden = true
            } else {
                self?.searchView.noResult.isHidden = true
                self?.searchView.searchedMovieCollectionView.isHidden = false
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
            viewModel.prefetchItems(indexPath: item)
        }
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if viewModel.keyword == searchBar.text! { return }
        viewModel.keyword = searchBar.text!
        viewModel.completion!(viewModel.keyword)
        viewModel.input.typedKeyword.value = viewModel.keyword
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.searchedResult[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchedMovieCollectionViewCell.id, for: indexPath) as! SearchedMovieCollectionViewCell
        cell.config(item: item)
        if item == viewModel.searchedResult.last {
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
        vc.selectedMovie = viewModel.searchedResult[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
