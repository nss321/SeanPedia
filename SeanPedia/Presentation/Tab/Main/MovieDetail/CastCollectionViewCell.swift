//
//  CastCollectionViewCell.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

import UIKit

import SnapKit
import Then

final class CastCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "CastCollectionViewCell"

    private let profileImageView = UIImageView()
    private let actorNameLabel = UILabel()
    private let characterNameLabel = UILabel()
    
    override func configHierarchy() {
        [profileImageView, actorNameLabel, characterNameLabel].forEach { contentView.addSubview($0) }
    }
    
    override func configLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        actorNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).inset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(smallMargin)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        characterNameLabel.snp.makeConstraints {
            $0.top.equalTo(actorNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(smallMargin)
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    override func configView() {
        profileImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            $0.contentMode = .scaleAspectFill
        }
        actorNameLabel.do {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .seanPediaWhite
        }
        characterNameLabel.do {
            $0.font = .systemFont(ofSize: 12)
            $0.textColor = .seanPediaGray
        }
    }
    
    func config(item: CastInfo) {
        if let profilePath = item.profile_path, let url = URL(string: Urls.w45Profile() + profilePath) {
            profileImageView.kf.setImage(with: url)
        } else {
            print(#function, "actor profile path nil")
            profileImageView.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.seanPediaGray, renderingMode: .alwaysOriginal)
        }
        actorNameLabel.text = item.name
        characterNameLabel.text = item.character
    }
}
