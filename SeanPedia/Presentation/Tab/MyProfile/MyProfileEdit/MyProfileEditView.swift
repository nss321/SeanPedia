//
//  MyProfileView.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

import SnapKit
import Then

final class MyProfileEditView: ProfileEdit {
    
    
    override func configHierarchy() {
        super.configHierarchy()
    }
    
    override func configLayout() {
        super.configLayout()
    }
    
    override func configView() {
        super.configView()
    }
    
    func configuredProfile() {
        print(#function, nicknameTextField.text!, profileImageView.selectedImage)
    }
}
