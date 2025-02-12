//
//  MovieDetailView.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MovieDetailView: BaseView {
    
    private let verticalScrollView = UIScrollView()
    private let container = UIView()
    let backDropHorizontalScrollView = UIScrollView()
    let backDropPageControl = UIPageControl()
    private var pages: [UIView] = [] {
        didSet {
            self.configPaging()
        }
    }
    
    private let infoLabel = UILabel()
    private let synopsisLabel = UILabel()
    private let overview = UILabel()
    private let foldButton = UIButton()
    private var config = UIButton.Configuration.plain()
    private let castLabel = UILabel()
    let castCollectionView = BaseCollectionView()
    private let posterLabel = UILabel()
    let posterCollectionView = BaseCollectionView()
    
    private var isFolded = false {
        didSet {
            var title = AttributedString(self.isFolded ? "Hide" : "More")
            title.font = UIFont.systemFont(ofSize: 16)
            config.attributedTitle = title
            self.foldButton.configuration = config
            self.overview.numberOfLines = self.isFolded ? 0 : 3
        }
    }
    
    let dummyView = UIView()
    
    override func configHierarchy() {
        addSubview(verticalScrollView)
        verticalScrollView.addSubview(container)
        [
            backDropHorizontalScrollView,
            backDropPageControl,
            infoLabel,
            synopsisLabel,
            overview,
            foldButton,
            castLabel,
            castCollectionView,
            posterLabel,
            posterCollectionView,
            
            dummyView
        ].forEach { container.addSubview($0) }
    }
    
    override func configLayout() {
        verticalScrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        container.snp.makeConstraints {
            $0.edges.equalTo(verticalScrollView.contentLayoutGuide)
            $0.width.equalTo(verticalScrollView.frameLayoutGuide)
        }
        backDropHorizontalScrollView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(screenWidth * 0.562)
        }
        backDropPageControl.snp.makeConstraints {
            $0.bottom.equalTo(backDropHorizontalScrollView.snp.bottom).inset(mediumMargin)
            $0.centerX.equalToSuperview()
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(backDropHorizontalScrollView.snp.bottom).offset(smallMargin)
            $0.centerX.equalToSuperview()
        }
        synopsisLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(mediumMargin)
        }
        foldButton.snp.makeConstraints {
            $0.centerY.equalTo(synopsisLabel)
            $0.trailing.equalToSuperview().inset(mediumMargin)
        }
        overview.snp.makeConstraints {
            $0.top.equalTo(synopsisLabel.snp.bottom).offset(mediumMargin)
            $0.horizontalEdges.equalToSuperview().inset(mediumMargin)
        }
        castLabel.snp.makeConstraints {
            $0.top.equalTo(overview.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(mediumMargin)
        }
        castCollectionView.snp.makeConstraints {
            $0.top.equalTo(castLabel.snp.bottom).offset(mediumMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(80+smallMargin)
        }
        posterLabel.snp.makeConstraints {
            $0.top.equalTo(castCollectionView.snp.bottom).offset(largeMargin)
            $0.leading.equalToSuperview().inset(mediumMargin)
        }
        posterCollectionView.snp.makeConstraints {
            $0.top.equalTo(posterLabel.snp.bottom).offset(mediumMargin)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(screenHeight * 0.2)
            $0.bottom.greaterThanOrEqualToSuperview().inset(largeMargin)
        }
    }
    
    override func configView() {
        backDropHorizontalScrollView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        infoLabel.do {
            $0.attributedText = configInfoLabel(date: "2024-12-24", voteAvg: 8.0, genre: ["액션, 스릴러"])
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .seanPediaGray
        }
        synopsisLabel.do {
            $0.text = "Synopsis"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .seanPediaWhite
        }
        foldButton.do {
            var title = AttributedString("More")
            title.font = UIFont.systemFont(ofSize: 16)
            config.attributedTitle = title
            config.baseForegroundColor = .seanPediaAccent
            config.background.backgroundColor = .seanPediaBlack
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            $0.configuration = config
            $0.addAction(UIAction(handler: { _ in
                self.isFolded.toggle()
            }), for: .touchUpInside)
        }
        overview.do {
            $0.text = "우연히 같은 날, 같은 예식장에 두 개의 결혼식이 예약되며 각 신부의 측근들은 가족의 특별한 순간을 지켜야만 하는 어려움을 직면하게 된다. 그리고 사랑하는 이들의 잊을 수 없는 축하 행사를 계획대로 진행하기 위해서라면 어떤 일도 마다하지 않으려는 한 신부의 아버지 와 다른 신부의 언니가 박장대소할 결단력과 투지의 대결에서 혼란스러운 정면 대결을 하게 된다."
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .seanPediaWhite
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
        }
        castLabel.do {
            $0.text = "Case"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .seanPediaWhite
        }
        castCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            $0.collectionViewLayout = layout
            $0.contentInset = UIEdgeInsets(top: 0, left: CGFloat(mediumMargin), bottom: 0, right: CGFloat(mediumMargin))
            $0.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        }
        posterLabel.do {
            $0.text = "Poster"
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .seanPediaWhite
        }
        posterCollectionView.do {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            $0.collectionViewLayout = layout
            $0.contentInset = UIEdgeInsets(top: 0, left: CGFloat(mediumMargin), bottom: 0, right: CGFloat(mediumMargin))
            $0.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)

        }
    }
    
    private func configPaging() {
        backDropHorizontalScrollView.do {
            $0.subviews.forEach {
                $0.removeFromSuperview()
            }
            $0.contentSize = CGSize(
                width: screenWidth * CGFloat(pages.count),
                height: screenWidth * 0.562
            )
            for (index, page) in pages.enumerated() {
                page.frame = CGRect(
                    x: screenWidth * CGFloat(index),
                    y: 0,
                    width: screenWidth,
                    height: screenWidth * 0.562
                )
                $0.addSubview(page)
            }
        }
        
        backDropPageControl.do {
            $0.numberOfPages = pages.count
            $0.currentPage = 0
        }
    }
    
    func configPages(data: [String]) {
        var pages: [UIView] = []
        data.forEach {
            let imageView = UIImageView()
            if let url = URL(string: Urls.w300Backdrop() + $0) {
                imageView.kf.setImage(with: url)
                pages.append(imageView)
            } else {
                imageView.image = UIImage(systemName: "xmark")
                pages.append(imageView)
            }
        }
        self.pages = pages
    }
    
    func fetchMovieData(movie: MovieInfo?) {
        if let movie {
            overview.text = movie.overview.isEmpty ? "요약 정보가 제공되지 않습니다." : movie.overview
            var genre: [String] = []
            
            for i in 0..<movie.genre_ids.count {
                if i > 1 {
                    break
                } else {
                    genre.append("\(Genre.genreId(movie.genre_ids[i]))")
                }
            }
            infoLabel.attributedText = configInfoLabel(date: movie.release_date, voteAvg: movie.vote_average, genre: genre)
        } else {
            overview.text = "영화 정보를 불러올 수 없습니다."
            infoLabel.text = "영화 정보를 불러올 수 없음"
        }
    }
    
    private func configInfoLabel(date: String, voteAvg: Double, genre: [String]) -> NSAttributedString {
        let calendar = NSTextAttachment()
        let starFill = NSTextAttachment()
        let filmFill = NSTextAttachment()
        calendar.image = UIImage(
            systemName: "calendar",
            withConfiguration: UIImage.SymbolConfiguration.init(font: .systemFont(ofSize: 12))
        )?.withTintColor(.seanPediaGray)
        starFill.image = UIImage(
            systemName: "star.fill",
            withConfiguration: UIImage.SymbolConfiguration.init(font: .systemFont(ofSize: 12))
        )?.withTintColor(.seanPediaGray)
        filmFill.image = UIImage(
            systemName: "film.fill",
            withConfiguration: UIImage.SymbolConfiguration.init(font: .systemFont(ofSize: 12))
        )?.withTintColor(.seanPediaGray)

        let attrstr = NSMutableAttributedString(string: "")
        attrstr.append(NSAttributedString(attachment: calendar))
        attrstr.append(NSAttributedString(string: "  \(date)  |  "))
        attrstr.append(NSAttributedString(attachment: starFill))
        attrstr.append(NSAttributedString(string: "  \(voteAvg)  |  "))
        attrstr.append(NSAttributedString(attachment: filmFill))
        attrstr.append(NSAttributedString(string: "  \(genre.joined(separator: ", "))"))
//        attrstr.addAttributes([
//            .foregroundColor : UIColor.seanPediaGray,
//            .font : UIFont.systemFont(ofSize: 14)
//        ], range: NSRange(location: 0, length: 100))
        
        return attrstr
    }
}
