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
    
    override func configHierarchy() {
        addSubview(searchBar)
    }
    
    override func configLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(-largeMargin/2)
            $0.horizontalEdges.equalToSuperview().inset(smallMargin)
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
    }
}
