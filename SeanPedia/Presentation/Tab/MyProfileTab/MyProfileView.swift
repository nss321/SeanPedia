//
//  MyProfileView.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

import SnapKit
import Then

final class MyProfileView: BaseView {
    
    let profileCard = ProfileCard()
    let settingCollectionView = BaseCollectionView()
    
    override func configHierarchy() {
        addSubview(profileCard)
        addSubview(settingCollectionView)
    }
    
    override func configLayout() {
        profileCard.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(screenHeight * 0.15)
        }
        settingCollectionView.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(largeMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        settingCollectionView.do {
            $0.contentInset = UIEdgeInsets(top: 0, left: CGFloat(mediumMargin), bottom: 0, right: CGFloat(mediumMargin))
            $0.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.id)
        }
    }
}


final class SettingCollectionViewCell: BaseCollectionViewCell {
    static let id = "SettingCollectionViewCell"

    let menuLabel = UILabel()
    let seperator = UIView()
    
    override func configHierarchy() {
        contentView.addSubview(menuLabel)
        contentView.addSubview(seperator)
    }
    override func configLayout() {
        menuLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(mediumMargin)
        }
        seperator.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(mediumMargin)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    override func configView() {
        isUserInteractionEnabled = false
        menuLabel.do {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .seanPediaWhite
        }
        seperator.do {
            $0.backgroundColor = .seanPediaGray.withAlphaComponent(0.5)
        }
    }
    func config(item: String) {
        menuLabel.text = item
    }
    
}
