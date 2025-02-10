//
//  ProfileImageCollectionView.swift
//  SeanPedia
//
//  Created by BAE on 1/29/25.
//

import UIKit

import SnapKit
import Then


final class ProfileImageCollectionView: BaseCollectionView {
    
    override func configView() {
        super.configView()
        register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
}

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "ProfileImageCollectionViewCell"
    
    lazy var profile = ProfileCircle(
        isRepresented: false,
        diemeter: (Int(screenWidth) - largeMargin * 2 - smallMargin * 3) / 4
    )
    
    override func configHierarchy() {
        contentView.addSubview(profile)
    }
    
    override func configLayout() {
        profile.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configCell(image: String) {
        profile.configImage(image: image)
    }
}
