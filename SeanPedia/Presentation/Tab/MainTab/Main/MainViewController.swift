//
//  MainViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

final class MainViewController: BaseViewController {
    
    let mainView = MainView()
    let viewModel = MainViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNoti), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainView.profileCard.updateProfileCard()
        if viewModel.recentSearchKeywords.isEmpty {
            mainView.recentSearchCollectionView.isHidden = true
            mainView.noResult.isHidden = false
        } else {
            mainView.recentSearchCollectionView.isHidden = false
            mainView.noResult.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveRecentSearch()
    }
    
    private func bind() {
        viewModel.output.outputTodayMovie.bind { [weak self] _ in
            self?.mainView.todayMovieCollectionView.reloadData()
        }
        viewModel.output.outputKeyword.bind { [weak self] _ in
            self?.mainView.recentSearchCollectionView.reloadData()
        }
        viewModel.output.outputProfile.lazyBind { [weak self] profile in
            if let profile {
                self?.mainView.profileCard.setProfileCard(profile: profile)
            } else {
                print(#function, "failed to unwrapping profile. selected profile image didn't changed.")
            }
        }
    }
    
    override func configView() {
        mainView.profileCard.setGestureToProfileContainer(gesture: UITapGestureRecognizer(target: self, action: #selector(presentProfileSettingViewController)))
        mainView.deleteSearchingHistoryButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.removeAllofKeyword()
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
            primaryAction: UIAction(handler: { [weak self] _ in
                let vc = SearchViewController()
                vc.completion = { [weak self] keyword in
                    self?.viewModel.input.inputKeyword.value = keyword
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }))
    }
    
    @objc private func presentProfileSettingViewController() {
        print(#function, "profile card tapped")
        let vc = MyProfileEditViewController()
        vc.completion = { [weak self] profile in
            self?.viewModel.input.inputProfile.value = profile
        }
        let presentVC = UINavigationController(rootViewController: vc)
        presentVC.modalPresentationStyle = .fullScreen
        present(presentVC, animated: true)
    }
    
    @objc
    func receiveNoti() {
        viewModel.saveRecentSearch()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            return viewModel.recentSearchKeywords.count
        case mainView.todayMovieCollectionView:
            return viewModel.todayMovieList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.id, for: indexPath) as! RecentSearchCollectionViewCell
            cell.config(title: viewModel.recentSearchKeywords[indexPath.item], action: UIAction(handler: { [weak self] _ in
                self?.viewModel.popKeyword(index: indexPath.item)
            }))
            return cell
        case mainView.todayMovieCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayMovieCollectionViewCell.id, for: indexPath) as! TodayMovieCollectionViewCell
            cell.config(item: viewModel.todayMovieList[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case mainView.recentSearchCollectionView:
            let label = UILabel(frame: .zero)
            label.text = viewModel.recentSearchKeywords[indexPath.item]
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
            vc.keyword = viewModel.recentSearchKeywords[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
            
        case mainView.todayMovieCollectionView:
            let vc = MovieDetailViewController()
            vc.selectedMovie = viewModel.todayMovieList[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print(#function, collectionView)
        }
    }
}
