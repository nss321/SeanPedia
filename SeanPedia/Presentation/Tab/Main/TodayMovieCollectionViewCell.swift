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
    
    override func configHierarchy() {
        [posterImage, movieNameLabel, movieSummaryLabel].forEach { contentView.addSubview($0) }
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
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
    }
    
    func config(item: MovieInfo) {
        if let url = URL(string: Urls.w154Poster() + item.poster_path)  {
            posterImage.kf.setImage(with: url)
        } else {
            print(#function, "\(item.title) 포스터 이미지 로드 실패")
            posterImage.image = UIImage(systemName: "xmark")
        }
        movieNameLabel.text = item.title
        movieSummaryLabel.text = item.overview.isEmpty ? "요약 정보가 없습니다." : item.overview
    }
}
