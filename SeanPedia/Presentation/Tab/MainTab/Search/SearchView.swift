//
//  SearchView.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

import SnapKit
import Then

final class SearchView: BaseView {
    
    let searchBar = UISearchBar()
    let searchedMovieCollectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let noResult = UILabel()
    
    override func configHierarchy() {
        addSubview(searchBar)
        addSubview(searchedMovieCollectionView)
        addSubview(noResult)
    }
    
    override func configLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(-largeMargin/2)
            $0.horizontalEdges.equalToSuperview().inset(smallMargin)
        }
        searchedMovieCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(smallMargin)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        noResult.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        searchBar.do {
            $0.placeholder = "영화를 검색해보세요."
            $0.searchBarStyle = .minimal
            $0.searchTextField.textColor = .seanPediaWhite
            $0.searchTextField.leftView?.tintColor = .seanPediaGray
            $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "영화를 검색해보세요.", attributes: [.foregroundColor : UIColor.seanPediaGray])
        }
        searchedMovieCollectionView.do {
            $0.contentInset = UIEdgeInsets(top: 0, left: CGFloat(mediumMargin), bottom: CGFloat(largeMargin), right: CGFloat(mediumMargin))
            $0.register(SearchedMovieCollectionViewCell.self, forCellWithReuseIdentifier: SearchedMovieCollectionViewCell.id)
        }
        noResult.do {
            $0.text = "원하는 검색결과를 찾지 못했습니다."
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .seanPediaGray
            $0.isHidden = true
        }
    }
}
