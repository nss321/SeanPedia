//
//  MainViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

final class MainViewController: BaseViewController {
    
    let mainView = MainView()
    var todayMovieList: [MovieInfo] = [] {
        didSet {
            mainView.todayMovieCollectionView.reloadData()
        }
    }
    
    var recentSearchKeywords: [String] = [] {
        didSet {
            mainView.recentSearchCollectionView.reloadData()
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentSearchKeywords = UserDefaultsManager.shared.recentSearchedKeywordList.keywords
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, recentSearchKeywords)
        fetchTodayMovieList()
        self.mainView.profileCard.updateProfileCard()
        if recentSearchKeywords.isEmpty {
            mainView.recentSearchCollectionView.isHidden = true
            mainView.noResult.isHidden = false
        } else {
            mainView.recentSearchCollectionView.isHidden = false
            mainView.noResult.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function, recentSearchKeywords)
        let newValue = RecentSearch(keywords: recentSearchKeywords)
        UserDefaultsManager.shared.setData(kind: .recentlyKeyword, type: RecentSearch.self, data: newValue)
    }
    
    override func configView() {
        mainView.profileCard.setGestureToProfileContainer(gesture: UITapGestureRecognizer(target: self, action: #selector(presentProfileSettingViewController)))
        mainView.deleteSearchingHistoryButton.addAction(UIAction(handler: { _ in
            self.recentSearchKeywords.removeAll()
        }), for: .touchUpInside)
    }
    
    override func configDelegate() {
        mainView.recentSearchCollectionView.delegate = self
        mainView.recentSearchCollectionView.dataSource = self
        mainView.todayMovieCollectionView.delegate = self
        mainView.todayMovieCollectionView.dataSource = self
    }
    
    override func configNavigation() {
        navigationItem.title = "오늘의 영화"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            primaryAction: UIAction(handler: { _ in
                let vc = SearchViewController()
                vc.completion = {
                    self.recentSearchKeywords.append($0)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }))
    }
    
    @objc private func presentProfileSettingViewController() {
        let vc = MyProfileEditViewController()
        vc.completion = { [self] profile in
            mainView.profileCard.setProfileCard(profile: profile)
        }
        let presentVC = UINavigationController(rootViewController: vc)
        presentVC.modalPresentationStyle = .fullScreen
        present(presentVC, animated: true)
    }
    
    func fetchTodayMovieList() {
        NetworkService.shared.callPhotoRequest(api: .trending, type: TodayMovie.self) {
            self.todayMovieList = $0.results
        } failureHandler: { _ in
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            return recentSearchKeywords.count
        case mainView.todayMovieCollectionView:
            return todayMovieList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.id, for: indexPath) as! RecentSearchCollectionViewCell
            cell.config(title: recentSearchKeywords[indexPath.item], action: UIAction(handler: { _ in
                self.recentSearchKeywords.remove(at: indexPath.item)
                self.mainView.recentSearchCollectionView.reloadData()
            }))
            return cell
        case mainView.todayMovieCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell
            cell.config(item: todayMovieList[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            let label = UILabel(frame: .zero)
            label.text = recentSearchKeywords[indexPath.item]
            label.font = .systemFont(ofSize: 14)
            label.sizeToFit()
            let cellWidth = label.frame.width + CGFloat(smallMargin) * 4
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        case mainView.todayMovieCollectionView:
            return CGSize(width: screenWidth / 2, height: collectionView.frame.height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            return CGFloat(smallMargin / 2)
        case mainView.todayMovieCollectionView:
            return CGFloat(mediumMargin)
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            let vc = SearchViewController()
            vc.keyword = recentSearchKeywords[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
            
        case mainView.todayMovieCollectionView:
            let vc = MovieDetailViewController()
            vc.selectedMovie = todayMovieList[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print(#function, collectionView)
        }
    }
}
