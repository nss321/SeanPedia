//
//  TodayMovieCollectionViewCell.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "TodayMovieCollectionViewCell"
    
    private let posterImage = UIImageView()
    private let movieNameLabel = UILabel()
    private let movieSummaryLabel = UILabel()
    private let likeButton = UIButton()
    private var likeButtonConfig = UIButton.Configuration.plain()
    private var isLiked: Bool = false {
        didSet {
            self.likeButton.configuration?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")?.withTintColor(.seanPediaAccent, renderingMode: .alwaysOriginal)
        }
    }
    private var alreadyLiked = false
    private var id = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isLiked = false
        alreadyLiked = false
        likeButton.configuration?.image = UIImage(systemName: "heart")?.withTintColor(.seanPediaAccent, renderingMode: .alwaysOriginal)
    }
    
    override func configHierarchy() {
        [posterImage, movieNameLabel, movieSummaryLabel, likeButton].forEach { contentView.addSubview($0) }
    }
    
    override func configLayout() {
        posterImage.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.8)
        }
        movieNameLabel.snp.makeConstraints {
            $0.top.equalTo(posterImage.snp.bottom).offset(smallMargin)
            $0.leading.equalToSuperview()
        }
        movieSummaryLabel.snp.makeConstraints {
            $0.top.equalTo(movieNameLabel.snp.bottom).offset(smallMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        likeButton.snp.makeConstraints {
            $0.top.equalTo(movieNameLabel.snp.top)
            $0.leading.greaterThanOrEqualTo(movieNameLabel.snp.trailing)
            $0.trailing.equalToSuperview()
        }
    }
    
    override func configView() {
        posterImage.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.contentMode = .scaleAspectFill
        }
        movieNameLabel.do {
            $0.textColor = .seanPediaWhite
            $0.font = .systemFont(ofSize: 16)
        }
        movieSummaryLabel.do {
            $0.textColor = .seanPediaWhite
            $0.font = .systemFont(ofSize: 12)
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        likeButton.do {
            likeButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            likeButtonConfig.image = UIImage(systemName: "heart")?.withTintColor(.seanPediaAccent, renderingMode: .alwaysOriginal)
            $0.configuration = likeButtonConfig
            
            $0.addAction(UIAction(handler: { _ in
                self.isLiked.toggle()
            }), for: .touchUpInside)
        }
    }
    
    func config(item: MovieInfo) {
        print(#function, item.title, "config!!")
        if let url = URL(string: Urls.w154Poster() + item.poster_path)  {
            posterImage.kf.setImage(with: url)
        } else {
            print(#function, "\(item.title) 포스터 이미지 로드 실패")
            posterImage.image = UIImage(systemName: "xmark")
        }
        movieNameLabel.text = item.title
        movieSummaryLabel.text = item.overview.isEmpty ? "요약 정보가 없습니다." : item.overview
        
        self.id = item.id
        if UserDefaultsManager.shared.likedList.contains(item.id) {
            self.isLiked = true
            self.alreadyLiked = true
        }
    }
    
    private func saveLikeState() {
        var newList = UserDefaultsManager.shared.likedList
        if self.isLiked && !alreadyLiked {
            newList.append(self.id)
            UserDefaultsManager.shared.setData(kind: .likedMovie, type: [Int].self, data: newList)
        } else if !self.isLiked && alreadyLiked {
            if let index = newList.firstIndex(of: self.id) {
                newList.remove(at: index)
                UserDefaultsManager.shared.setData(kind: .likedMovie, type: [Int].self, data: newList)
            }
        }
    }
}
