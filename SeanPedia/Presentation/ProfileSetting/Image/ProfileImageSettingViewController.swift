//
//  ProfileImageSettingViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/29/25.
//

import UIKit

final class ProfileImageSettingViewController: BaseViewController {
    
    private let profileImageSettingView = ProfileImageSettingView()
    
    override func loadView() {
        view = profileImageSettingView
    }
    
    let viewModel = ProfileImageSettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedImage = profileImageSettingView.selectedImage {
            viewModel.input.selectedImage.value = selectedImage
        }
    }
    
    private func bind() {
        viewModel.output.selectedImage.lazyBind { [weak self] selectedImage in
            guard let completion = self?.viewModel.dismissCompletion, let selectedImage else { fatalError() }
            completion(selectedImage)
        }
    }
    
    override func configView() {
        profileImageSettingView.selectedImage = viewModel.selectedProfileImage
        profileImageSettingView.configView()
    }
    
    override func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
        navigationItem.title = "프로필 이미지 설정"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func configDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        profileImageSettingView.collectionView.dataSource = self
        profileImageSettingView.collectionView.delegate = self
    }
}

extension ProfileImageSettingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileImage.profileList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profiles = ProfileImage.profileList()
        let item = profiles[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.configCell(image: item)
        
        // 기존 프로필 사진을 받아와서 선택된 이미지로 표기 및 해당 인덱스를 저장해 둠.
        if viewModel.selectedProfileImage == item {
            cell.profile.selectStateToggle()
            viewModel.lastSelected = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let diemater = profileImageCollectionViewDiemeter
        return CGSize(width: diemater, height: diemater)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, viewModel.lastSelected ?? "no value")
        if let lastSelected = viewModel.lastSelected {
            if lastSelected == indexPath {
                return
            } else {
                let cell = collectionView.cellForItem(at: lastSelected) as! ProfileImageCollectionViewCell
                cell.profile.selectStateToggle()
            }
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileImageCollectionViewCell
        cell.profile.selectStateToggle()
        
        viewModel.lastSelected = indexPath
        
        let profiles = ProfileImage.profileList()
        profileImageSettingView.selectedImage = profiles[indexPath.item]
        profileImageSettingView.configView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
}

extension ProfileImageSettingViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
