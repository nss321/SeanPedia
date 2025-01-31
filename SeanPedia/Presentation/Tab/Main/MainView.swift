//
//  MainView.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

import SnapKit
import Then

final class MainView: BaseView {
    
    let profileCard = ProfileCard()
    let recentSearchLabel = UILabel()
    let deleteSearchingHistoryButton = UIButton()
    let recentSearchCollectionView = BaseCollectionView()
    let recentSearchNotiLabel = UILabel()
    let todayMovieLabel = UILabel()
    let todayMovieCollectionView = BaseCollectionView()
    
    override func configHierarchy() {
        [
            profileCard,
            recentSearchLabel,
            deleteSearchingHistoryButton,
            recentSearchCollectionView,
            recentSearchNotiLabel,
            todayMovieLabel,
            todayMovieCollectionView,
        ].forEach { addSubview($0) }
    }
    
    override func configLayout() {
        profileCard.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(screenHeight * 0.15)
        }
        recentSearchLabel.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(largeMargin)
        }
        deleteSearchingHistoryButton.snp.makeConstraints {
            $0.top.equalTo(recentSearchLabel.snp.top)
            $0.trailing.equalToSuperview().inset(largeMargin)
        }
        recentSearchCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentSearchLabel.snp.bottom).offset(mediumMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        }
        recentSearchNotiLabel.snp.makeConstraints {
            $0.center.equalTo(recentSearchCollectionView)
        }
        todayMovieLabel.snp.makeConstraints {
            $0.top.equalTo(recentSearchCollectionView.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(largeMargin)
        }
        todayMovieCollectionView.snp.makeConstraints {
            $0.top.equalTo(todayMovieLabel.snp.bottom).offset(largeMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configView() {
        recentSearchLabel.do {
            $0.text = "최근 검색어"
            $0.textColor = .seanPediaWhite
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
        deleteSearchingHistoryButton.do {
            var config = UIButton.Configuration.plain()
            var title = AttributedString("전체 삭제")
            title.foregroundColor = UIColor.seanPediaAccent
            title.font = UIFont.systemFont(ofSize: 14)
            config.attributedTitle = title
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            $0.configuration = config
            $0.addAction(UIAction(handler: { _ in
                print(#function)
            }), for: .touchUpInside)
        }
        recentSearchNotiLabel.do {
            $0.text = "최근 검색된 내역이 없습니다."
            $0.textColor = .seanPediaGray
            $0.font = .systemFont(ofSize: 12)
            $0.isHidden = true
        }
        todayMovieLabel.do {
            $0.text = "오늘의 영화"
            $0.textColor = .seanPediaWhite
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
        recentSearchCollectionView.do {
            $0.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.id)
            $0.contentInset = UIEdgeInsets(top: 0, left: CGFloat(mediumMargin), bottom: 0, right: CGFloat(mediumMargin))
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            $0.collectionViewLayout = layout
        }
        todayMovieCollectionView.do {
            $0.register(TodayMovieCollectionViewCell.self, forCellWithReuseIdentifier: TodayMovieCollectionViewCell.id)
            $0.contentInset = UIEdgeInsets(top: 0, left: CGFloat(mediumMargin), bottom: 0, right: CGFloat(mediumMargin))
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            $0.collectionViewLayout = layout
        }
    }
}
