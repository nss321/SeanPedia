//
//  ProfileCard.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

import SnapKit
import Then

final class ProfileCard: BaseView {
    
    private let profileContainer = UIView()
    private let profileImageView = ProfileCircle(isRepresented: true, diemeter: 48, isSelected: true)
    private let nicknameLabel = UILabel()
    private let signupDateLabel = UILabel()
    private let movieBoxButton = UIButton()
    private var buttonConfig = UIButton.Configuration.plain()
    private let rightChevron = UIImageView()
    
    
    override func configHierarchy() {
        [profileContainer].forEach { addSubview($0) }
        [profileImageView, nicknameLabel, signupDateLabel, movieBoxButton, rightChevron].forEach { profileContainer.addSubview($0) }
        
    }
    
    override func configLayout() {
        profileContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(mediumMargin)
            $0.height.equalTo(screenHeight * 0.15)
        }
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(mediumMargin)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(mediumMargin)
        }
        signupDateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nicknameLabel.snp.leading)
        }
        movieBoxButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(mediumMargin)
            $0.horizontalEdges.equalToSuperview().inset(largeMargin)
            $0.bottom.equalToSuperview().inset(mediumMargin)
        }
        rightChevron.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.lessThanOrEqualTo(nicknameLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(mediumMargin)
        }
        
    }
    
    override func configView() {
        
        profileContainer.do {
            $0.backgroundColor = .seanPediaGray.withAlphaComponent(0.3)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
        profileImageView.do {
            $0.configImage(image: "profile_0")
            $0.backgroundColor = .clear
        }
        nicknameLabel.do {
            $0.text = "달콤한 기모청바지"
            $0.textColor = .seanPediaWhite
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }
        signupDateLabel.do {
            $0.text = "25.01.24 가입"
            $0.textColor = .seanPediaGray.withAlphaComponent(0.7)
            $0.font = .systemFont(ofSize: 12)
        }
        movieBoxButton.do {
            var attrTitle = AttributedString("0개의 무비박스 보관중")
            attrTitle.foregroundColor = UIColor.seanPediaWhite
            attrTitle.font = .systemFont(ofSize: 14, weight: .bold)
            buttonConfig.attributedTitle = attrTitle
            buttonConfig.cornerStyle = .medium
            buttonConfig.background.backgroundColor = .seanPediaAccent.withAlphaComponent(0.7)
            
            $0.configuration = buttonConfig
            $0.isUserInteractionEnabled = false
        }
        rightChevron.do {
            $0.image = UIImage(systemName: "chevron.right")?.withTintColor(.seanPediaGray, renderingMode: .alwaysOriginal)
        }
    }
    
    func setGestureToProfileContainer(gesture: UIGestureRecognizer) {
        addGestureRecognizer(gesture)
    }
}
