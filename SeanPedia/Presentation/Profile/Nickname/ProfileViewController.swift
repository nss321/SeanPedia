//
//  ProfileViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    let nicknameView = ProfileNicknameView()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func configView() {
        nicknameView.completeButton.configButtonInfo(title: "완료", action: UIAction(handler: { _ in
            self.nicknameView.configuredProfile()
        }))
        
        nicknameView.profileImageView.changeAction(gesture: UITapGestureRecognizer(target: self, action: #selector(navigateProfileSettingView)))
     
    }
    
    override func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }),
            menu: nil)
        navigationItem.title = "프로필 설정"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func configDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc private func navigateProfileSettingView(_ sender: UITapGestureRecognizer) {
        let vc = ProfileImageSettingViewController()
        vc.selectedProfileImage = nicknameView.profileImageView.selectedImage
        vc.dismissCompletion = {
            self.nicknameView.profileImageView.selectedImage = $0
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
