//
//  MyProfileViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

final class MyProfileViewController: BaseViewController {
    
    private let myProfileView = MyProfileView()
    
    override func loadView() {
        view = myProfileView
    }
    
    override func configHierarchy() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        
        myProfileView.profileImageView.changeAction(gesture: UITapGestureRecognizer(target: self, action: #selector(navigateProfileImageEditView)))
        print(#function)
    }
    
    override func configDelegate() {
        
    }
    
    override func configNavigation() {
        navigationItem.title = "프로필 편집"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "xmark"),
            primaryAction: UIAction(handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }),
            menu: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            image: nil,
            primaryAction: UIAction(handler: { _ in
                self.dismiss(animated: true) {
                    print("저장!!저장!!저장!!")
                    self.myProfileView.configuredProfile()
                }
            }),
            menu: nil)
        
    }
    
    @objc private func navigateProfileImageEditView(_ sender: UITapGestureRecognizer) {
        print(#function)
        let vc = MyProfileImageEditViewController()
        vc.selectedProfileImage = myProfileView.profileImageView.selectedImage
        vc.dismissCompletion = {
            self.myProfileView.profileImageView.selectedImage = $0
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
