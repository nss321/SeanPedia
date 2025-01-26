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
            print(#function)
        }))
     
    }
    
    override func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "chevron.left")?.withTintColor(.seanPediaAccent, renderingMode: .alwaysOriginal),
            primaryAction: UIAction(handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }),
            menu: nil)
        navigationController?.title = "프로필 설정"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension ProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
