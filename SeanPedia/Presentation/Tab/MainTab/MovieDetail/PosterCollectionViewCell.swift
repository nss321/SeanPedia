//
//  PosterCollectionViewCell.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

import UIKit

import SnapKit
import Then

final class PosterCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "PosterCollectionViewCell"

    private let posterImageView = UIImageView()
    
    override func configHierarchy() {
        contentView.addSubview(posterImageView)
    }
    
    override func configLayout() {
        posterImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configView() {
        posterImageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func config(item: PosterImage) {
        if let url = URL(string: Urls.w154Poster() + item.filePath) {
            posterImageView.kf.setImage(with: url)
        } else {
            print(#function, "poster profile path nil")
            posterImageView.image = UIImage(systemName: "xmark")?.withTintColor(.seanPediaGray)
        }
    }
}
