//
//  ProfileEdit.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

import SnapKit
import Then

class ProfileEdit: BaseView {
    let profileImageView = ProfileCircle(isRepresented: true, diemeter: Int(UIScreen.main.bounds.width) / 4)
    let nicknameTextField = UITextField()
    let nicknameTextFieldUnderline = UIView()
    let notiLabel = UILabel()
    
    override func configHierarchy() {
        [profileImageView, nicknameTextField, nicknameTextFieldUnderline, notiLabel].forEach { addSubview($0) }
    }
    
    override func configLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
        }
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(mediumMargin)
            $0.height.equalTo(44)
        }
        nicknameTextFieldUnderline.snp.makeConstraints {
            $0.horizontalEdges.equalTo(nicknameTextField)
            $0.top.equalTo(nicknameTextField.snp.bottom)
            $0.height.equalTo(1)
        }
        notiLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldUnderline.snp.bottom).offset(smallMargin)
            $0.horizontalEdges.equalTo(nicknameTextFieldUnderline).inset(smallMargin)
        }
    }
    
    override func configView() {
        nicknameTextField.do {
            $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력하세요.", attributes: [.foregroundColor : UIColor.seanPediaGray])
            $0.font = .systemFont(ofSize: 12)
            $0.borderStyle = .none
            $0.backgroundColor = .seanPediaBlack
            $0.leftViewMode = .always
            $0.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: mediumMargin, height: 0))
            $0.textColor = .seanPediaWhite
        }
        
        nicknameTextFieldUnderline.backgroundColor = .seanPediaWhite
        
        notiLabel.do {
            $0.textColor = .seanPediaAccent
            $0.font = .systemFont(ofSize: 11)
        }
        
        guard let profile = UserDefaultsManager.shared.getStoredData(kind: .profile, type: Profile.self) else {
            profileImageView.selectedImage = ProfileImage.randomProfile()
            nicknameTextField.text = ""
            return
        }
        
        profileImageView.selectedImage = profile.profileImage
        nicknameTextField.text = profile.nickname
    }
}

