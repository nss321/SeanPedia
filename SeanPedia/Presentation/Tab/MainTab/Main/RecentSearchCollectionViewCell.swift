//
//  RecentSearchCollectionViewCell.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

import SnapKit
import Then

final class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "RecentSearchCollectionViewCell"
    
    let container = UIView()
    let keyword = UILabel()
    let deleteButton = UIButton()
    private var config = UIButton.Configuration.plain()
    private var buttonAction = UIAction { _ in
        
    }
    
    override func configHierarchy() {
        contentView.addSubview(container)
        [keyword, deleteButton].forEach { container.addSubview($0) }
    }
    
    override func configLayout() {
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keyword.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(smallMargin)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(keyword.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(smallMargin)
        }
    }
    
    override func configView() {
        container.do {
            $0.clipsToBounds = true
            $0.backgroundColor = .seanPediaLightGray
            $0.layer.cornerRadius = 14
        }
        
        keyword.do {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .seanPediaBlack
        }
        
        deleteButton.do {
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            config.background.backgroundColor = .seanPediaLightGray
            config.image = UIImage(
                systemName: "xmark",
                withConfiguration: UIImage.SymbolConfiguration(scale: .small))?
                .withTintColor(.seanPediaBlack, renderingMode: .alwaysOriginal)
            $0.configuration = config
        }
    }
    
    func config(title: String, action: UIAction) {
        keyword.text = title
        deleteButton.removeAction(self.buttonAction, for: .touchUpInside)
        deleteButton.addAction(action, for: .touchUpInside)
        self.buttonAction = action
    }
}
