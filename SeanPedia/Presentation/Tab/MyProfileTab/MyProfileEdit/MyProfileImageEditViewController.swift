//
//  MyProfileImageEditViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//


import UIKit

final class MyProfileImageEditViewController: BaseViewController {
    
    private var profileImageList: [String] {
        ProfileImage.allCases.map { $0.profileImage }
    }
    
    private let profileImageSettingView = ChooseProfileImage()
    private var lastSelected: IndexPath?
    var selectedProfileImage: String?
    var dismissCompletion: ((String) -> Void)?
    
    override func loadView() {
        view = profileImageSettingView
    }
    
    override func configView() {
        profileImageSettingView.selectedImage = selectedProfileImage
        profileImageSettingView.configView()
    }
    
    override func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { _ in
                guard let completion = self.dismissCompletion, let selectedImage = self.profileImageSettingView.selectedImage else { fatalError() }
                completion(selectedImage)
                
                self.navigationController?.popViewController(animated: true)
            }),
            menu: nil)
        navigationItem.title = "프로필 이미지 편집"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func configDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        profileImageSettingView.collectionView.dataSource = self
        profileImageSettingView.collectionView.delegate = self
    }
}

extension MyProfileImageEditViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = profileImageList[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell
                
        cell.configCell(image: item)
        
        if selectedProfileImage == item {
            cell.profile.selectStateToggle()
            lastSelected = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let diemater = profileImageCollectionViewDiemeter
        return CGSize(width: diemater, height: diemater)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, lastSelected ?? "no value")
        if let lastSelected {
            if lastSelected == indexPath {
//                print(#function, "select same cell")
                return
            } else {
                let cell = collectionView.cellForItem(at: lastSelected) as! ProfileImageCollectionViewCell
                cell.profile.selectStateToggle()
            }
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileImageCollectionViewCell
        cell.profile.selectStateToggle()
        
        lastSelected = indexPath
        
        profileImageSettingView.selectedImage = profileImageList[indexPath.item]
        profileImageSettingView.configView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(smallMargin)
    }
    
}

extension MyProfileImageEditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
