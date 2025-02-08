//
//  SearchedMovieCollectionViewCell.swift
//  SeanPedia
//
//  Created by BAE on 2/1/25.
//

import UIKit

import SnapKit
import Then

final class SearchedMovieCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "SearchedMovieCollectionViewCell"

    private let posterImageView = UIImageView()
    private let moviewNameLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let firstGenre = UIButton()
    private let secondGenre = UIButton()
    private let likeButton = UIButton()
    private var likeButtonConfig = UIButton.Configuration.plain()
    private var genreButtonConfig = UIButton.Configuration.plain()
    private let seperator = UIView()
    private var isLiked: Bool = false {
        didSet {
            self.likeButton.configuration?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")?.withTintColor(.seanPediaAccent, renderingMode: .alwaysOriginal)
            self.saveLikeState()
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
        [
            posterImageView,
            moviewNameLabel,
            releaseDateLabel,
            firstGenre,
            secondGenre,
            likeButton,
            seperator
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configLayout() {
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(mediumMargin)
            $0.verticalEdges.equalToSuperview().inset(mediumMargin)
            $0.width.equalToSuperview().dividedBy(4)
        }
        moviewNameLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.top).offset(4)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(mediumMargin)
            $0.trailing.equalToSuperview().inset(mediumMargin)
        }
        releaseDateLabel.snp.makeConstraints {
            $0.top.equalTo(moviewNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(moviewNameLabel.snp.leading)
        }
        firstGenre.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom).inset(4)
            $0.leading.equalTo(moviewNameLabel.snp.leading)
        }
        secondGenre.snp.makeConstraints {
            $0.bottom.equalTo(posterImageView.snp.bottom).inset(4)
            $0.leading.equalTo(firstGenre.snp.trailing).offset(2)
        }
        likeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(mediumMargin)
            $0.bottom.equalTo(posterImageView.snp.bottom)
        }
        seperator.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(mediumMargin)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func configView() {
        posterImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
        }
        moviewNameLabel.do {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .seanPediaWhite
            $0.numberOfLines = 2
        }
        releaseDateLabel.do {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .seanPediaGray
        }
        firstGenre.do {
            $0.isUserInteractionEnabled = false
            $0.configuration = configGenreButton(title: "애니메이션")
        }
        secondGenre.do {
            $0.isUserInteractionEnabled = false
            $0.configuration = configGenreButton(title: "가족")
        }
        likeButton.do {
            likeButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            likeButtonConfig.image = UIImage(systemName: "heart")?.withTintColor(.seanPediaAccent, renderingMode: .alwaysOriginal)
            $0.configuration = likeButtonConfig
            
            $0.addAction(UIAction(handler: { _ in
                self.isLiked.toggle()
            }), for: .touchUpInside)
        }
        seperator.do {
            $0.backgroundColor = .seanPediaGray
        }
    }
    
    private func configGenreButton(title: String) -> UIButton.Configuration {
        var attrstr = AttributedString(title)
        attrstr.font = UIFont.systemFont(ofSize: 14)
        genreButtonConfig.attributedTitle = attrstr
        genreButtonConfig.background.backgroundColor = .seanPediaGray.withAlphaComponent(0.5)
        genreButtonConfig.baseForegroundColor = .seanPediaWhite
        genreButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
        genreButtonConfig.cornerStyle = .small
        
        return genreButtonConfig
    }
    
    func config(item: MovieInfo) {
        if let url = URL(string: Urls.w154Poster() + item.poster_path) {
            posterImageView.kf.setImage(with: url)
        } else {
            print(#function, "poster path nil")
            posterImageView.image = UIImage(systemName: "xmark")?.withTintColor(.seanPediaGray, renderingMode: .alwaysOriginal)
        }
        moviewNameLabel.text = item.title
        releaseDateLabel.text = item.release_date
        
        for i in 0..<item.genre_ids.count {
            if i > 1 {
                break
            } else {
                [firstGenre, secondGenre][i].configuration = configGenreButton(
                    title: Genre.genreId(item.genre_ids[i])
                )
            }
        }
        self.id = item.id
        if UserDefaultsManager.shared.likedList.likedMovie.contains(item.id) {
            self.isLiked = true
            self.alreadyLiked = true
        }
    }
    
    func lastCell() {
        seperator.isHidden = true
    }
    
    private func saveLikeState() {
        var newList = UserDefaultsManager.shared.likedList
        if self.isLiked && !alreadyLiked {
            newList.likedMovie.append(self.id)
            UserDefaultsManager.shared.setData(kind: .likedMovie, type: LikedList.self, data: newList)
        } else if !self.isLiked && alreadyLiked {
            if let index = newList.likedMovie.firstIndex(of: self.id) {
                newList.likedMovie.remove(at: index)
                UserDefaultsManager.shared.setData(kind: .likedMovie, type: LikedList.self, data: newList)
            }
        }
    }
}
