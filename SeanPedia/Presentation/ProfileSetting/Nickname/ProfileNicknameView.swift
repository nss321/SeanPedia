//
//  ProfileNicknameView.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import SnapKit
import Then

final class ProfileNicknameView: BaseView {
    
    let profileImageView = ProfileCircle(isRepresented: true, diemeter: Int(UIScreen.main.bounds.width) / 4)
    let nicknameTextField = UITextField()
    private let nicknameTextFieldUnderline = UIView()
    let notiLabel = UILabel()
    let completeButton = CustomCTAButton()
    private let mbtiLabel = UILabel()
    let mbtiCollectionViewStack = UIStackView()
    
    override func configHierarchy() {
        [profileImageView, nicknameTextField, nicknameTextFieldUnderline, notiLabel, completeButton, mbtiLabel, mbtiCollectionViewStack].forEach { addSubview($0) }
        
        (0...3).forEach {
            let collectionView = createCollectionView(tag: $0)
            mbtiCollectionViewStack.addArrangedSubview(collectionView)
        }
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
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.horizontalEdges.equalToSuperview().inset(mediumMargin)
        }
        mbtiLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(48)
            $0.leading.equalTo(nicknameTextField.snp.leading)
        }
        mbtiCollectionViewStack.snp.makeConstraints {
            $0.top.equalTo(mbtiLabel.snp.top)
            $0.leading.greaterThanOrEqualTo(mbtiLabel.snp.trailing)
            $0.trailing.equalTo(nicknameTextField.snp.trailing)
            $0.height.equalTo(96+mediumMargin)
        }
    }
    
    override func configView() {
        
        profileImageView.selectedImage = ProfileImage.randomProfile()
        
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
        
        completeButton.do {
            $0.isEnabled = false
        }
        
        mbtiLabel.do {
            $0.text = "MBTI"
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textColor = .seanPediaWhite
        }
        
        mbtiCollectionViewStack.do {
//            $0.layer.borderColor = UIColor.red.cgColor
//            $0.layer.borderWidth = 1
            $0.axis = .horizontal
            $0.spacing = CGFloat(smallMargin)
            $0.alignment = .center
        }
    }
    
    func configuredProfile() {
        print(#function, nicknameTextField.text!, profileImageView.selectedImage)
    }
    
    func createCollectionView(tag: Int) -> UICollectionView {
        let interSpacing = smallMargin
        let diameter = 48
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: diameter, height: diameter)
        let collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.tag = tag
        collectionView.backgroundColor = .clear
        collectionView.register(MBTICollectionViewCell.self, forCellWithReuseIdentifier: MBTICollectionViewCell.id)
        collectionView.snp.makeConstraints {
            $0.width.equalTo(diameter+2)
            $0.height.equalTo(diameter*2+smallMargin+2)
        }
        return collectionView
    }
}

final class MBTICollectionViewCell: BaseCollectionViewCell {
    static let id = "MBTICollectionViewCell"
    private let characterLabel = UILabel()
    var lastSelected = false
    override var isSelected: Bool {
        didSet {
            print(#function, isSelected)
            if isSelected {
                backgroundColor = .seanPediaAccent
                characterLabel.textColor = .white
            } else {
                backgroundColor = .seanPediaBlack
                characterLabel.textColor = .seanPediaGray
            }
            lastSelected = isSelected
        }
    }
    
    override func configHierarchy() {
        contentView.addSubview(characterLabel)
    }
    override func configLayout() {
        characterLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    override func configView() {
        layer.borderColor = UIColor.seanPediaGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
        backgroundColor = .clear
        characterLabel.do {
            $0.textColor = .seanPediaGray
            $0.font = .systemFont(ofSize: 16)
        }
    }
    
    func config(char: String) {
        characterLabel.text = char
    }
}

