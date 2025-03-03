//
//  MainViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MainViewController: BaseViewController {
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNoti), name: UIApplication.willResignActiveNotification, object: nil)
        print(#function, "viewdidload!!!!")
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
    
    override func bind() {
        viewModel.todayMovieList2
            .asDriver()
            .drive(
                mainView.todayMovieCollectionView.rx.items(cellIdentifier: TodayMovieCollectionViewCell.id, cellType: TodayMovieCollectionViewCell.self)) ({ _, element, cell in
                cell.config(item: element)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.keyword.bind { [weak self] _ in
            self?.mainView.recentSearchCollectionView.reloadData()
            
        }
        viewModel.output.profile.lazyBind { [weak self] profile in
            if let profile {
                self?.mainView.profileCard.setProfileCard(profile: profile)
            } else {
                print(#function, "failed to unwrapping profile. selected profile image didn't changed.")
            }
        }
        mainView.todayMovieCollectionView.rx.modelSelected(MovieInfo.self)
            .bind(with: self) { owner, item in
                print(item, "선택!!!")
            }
            .disposed(by: disposeBag)
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
    }
    
    override func configNavigation() {
        navigationItem.title = "오늘의 영화"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            primaryAction: UIAction(handler: { [weak self] _ in
                let vc = SearchViewController()
                vc.viewModel.completion = { [weak self] keyword in
                    self?.viewModel.input.keyword.value = keyword
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }))
    }
    
    @objc private func presentProfileSettingViewController() {
        print(#function, "profile card tapped")
        let vc = MyProfileEditViewController()
        vc.completion = { [weak self] profile in
            self?.viewModel.input.profile.value = profile
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
        return viewModel.recentSearchKeywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.id, for: indexPath) as! RecentSearchCollectionViewCell
        cell.config(title: viewModel.recentSearchKeywords[indexPath.item], action: UIAction(handler: { [weak self] _ in
            self?.viewModel.popKeyword(index: indexPath.item)
        }))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.text = viewModel.recentSearchKeywords[indexPath.item]
        label.font = .systemFont(ofSize: 14)
        label.sizeToFit()
        let cellWidth = label.frame.width + CGFloat(smallMargin) * 4
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SearchViewController()
        vc.viewModel.keyword = viewModel.recentSearchKeywords[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
