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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.saveRecentSearch()
    }
    
    override func bind() {
        viewModel.todayMovieList2
            .asDriver()
            .drive(mainView.todayMovieCollectionView.rx.items(cellIdentifier: TodayMovieCollectionViewCell.id, cellType: TodayMovieCollectionViewCell.self)) ({ _, element, cell in
                cell.config(item: element)
            })
            .disposed(by: disposeBag)
        
        viewModel.recentSearched
            .asDriver()
            .drive(mainView.recentSearchCollectionView.rx.items(cellIdentifier: RecentSearchCollectionViewCell.id, cellType: RecentSearchCollectionViewCell.self)) ({ _, element, cell in
                print("최근 검색어 목록:", element)
                cell.config(title: element, action: UIAction(handler: { _ in
                    print(element, "delete!!")
                }))
            })
            .disposed(by: disposeBag)
        
        viewModel.recentSearched
            .asDriver()
            .map { return $0.isEmpty }
            .drive(with: self) { owner, value in
                owner.mainView.recentSearchCollectionView.isHidden = value
                owner.mainView.noResult.isHidden = !value
            }
            .disposed(by: disposeBag)
        
        mainView.recentSearchCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
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
        
        mainView.recentSearchCollectionView.rx.modelSelected(String.self)
            .bind(with: self) { owner, item in
                print("\(item) selected!!")
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configView() {
        mainView.profileCard.setGestureToProfileContainer(gesture: UITapGestureRecognizer(target: self, action: #selector(presentProfileSettingViewController)))
        mainView.deleteSearchingHistoryButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.removeAllofKeyword()
        }), for: .touchUpInside)
    }
    
    override func configNavigation() {
        navigationItem.title = "오늘의 영화"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            primaryAction: UIAction(handler: { [weak self] _ in
                let vc = SearchViewController()
                vc.viewModel.completion = { [weak self] keyword in
//                    self?.viewModel.input.keyword.value = keyword
                    Observable.just(keyword)
                        .bind(with: self!) { owner, keyword in
                            let origin = owner.viewModel.recentSearched.value
                            owner.viewModel.recentSearched.accept(origin + [keyword])
                        }
                        .disposed(by: self!.disposeBag)
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

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
//        label.text = viewModel.recentSearchKeywords[indexPath.item]
        label.text = viewModel.recentSearched.value[indexPath.item]
        label.font = .systemFont(ofSize: 14)
        label.sizeToFit()
        let cellWidth = label.frame.width + CGFloat(smallMargin) * 4
        
        return CGSize(width: cellWidth, height: collectionView.frame.height)
    }
}
