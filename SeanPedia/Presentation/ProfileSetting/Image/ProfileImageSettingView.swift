//
//  ProfileImageSettingView.swift
//  SeanPedia
//
//  Created by BAE on 1/29/25.
//

import UIKit

import SnapKit

final class ProfileImageSettingView: BaseView {
    
    var selectedImage: String?
    var selectedImageView = ProfileCircle(isRepresented: true, diemeter: Int(UIScreen.main.bounds.width) / 4, isSelected: true)
    let collectionView = ProfileImageCollectionView()
    
    override func configHierarchy() {
        addSubview(selectedImageView)
        addSubview(collectionView)
    }
    
    override func configLayout() {
        selectedImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(selectedImageView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(largeMargin)
            $0.height.equalTo(profileImageCollectionViewDiemeter*3 + smallMargin*2)
        }
    }
    
    override func configView() {
        selectedImageView.configImage(image: selectedImage ?? "profile_0")
        collectionView.allowsMultipleSelection = false
    }
}


