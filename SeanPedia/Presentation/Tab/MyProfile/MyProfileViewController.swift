//
//  MyProfileViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

final class MyProfileViewController: BaseViewController {
    
    private let myProfileView = MyProfileView()
    private let settingMenus = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    let viewModel = MyProfileViewModel()
    
    override func loadView() {
        view = myProfileView
    }

    override func viewWillAppear(_ animated: Bool) {
        myProfileView.profileCard.updateProfileCard()
    }
    
    override func configView() {
        myProfileView.profileCard.setGestureToProfileContainer(gesture: UITapGestureRecognizer(target: self, action: #selector(presentProfileSettingViewController)))
    }
    
    override func configDelegate() {
        myProfileView.settingCollectionView.dataSource = self
        myProfileView.settingCollectionView.delegate = self
    }
    
    override func configNavigation() {
        navigationItem.title = "설정"
    
    }
    
    @objc private func presentProfileSettingViewController() {
        let vc = MyProfileEditViewController()
        vc.completion = { [self] profile in
            myProfileView.profileCard.setProfileCard(profile: profile)
        }
        let presentVC = UINavigationController(rootViewController: vc)
        presentVC.modalPresentationStyle = .fullScreen
        present(presentVC, animated: true)
    }
}

extension MyProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        settingMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = settingMenus[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCollectionViewCell.id, for: indexPath) as! SettingCollectionViewCell
        
        if item == settingMenus.last {
            cell.isUserInteractionEnabled = true
        }
        cell.config(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: screenWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath)
        showAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다.\n탈퇴 하시겠습니까?") { _ in
            print("탈퇴")
            UserDefaultsManager.shared.resetData()
            let vc = OnboardingViewController()
            
            self.navigationController?.pushNewRootController(root: UINavigationController(rootViewController: vc))
        } cancelHandler: { _ in
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
