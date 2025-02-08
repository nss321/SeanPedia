//
//  MyProfileEditViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

final class MyProfileEditViewController: BaseViewController {
    
    private let myProfileView = ProfileEdit()
    let viewModel = MyProfileEditViewModel()
    var completion: ((Profile) -> Void)?
    
    override func loadView() {
        view = myProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        viewModel.outputValidationText.bind { [self] string in
            myProfileView.notiLabel.text = string
        }
        viewModel.outputIsValid.bind { [self] bool in
            navigationItem.rightBarButtonItem?.isEnabled = bool
            myProfileView.notiLabel.textColor = bool ? .seanPediaWhite : .seanPediaAccent
        }

    }
    
    override func configView() {
        myProfileView.profileImageView.changeAction(gesture: UITapGestureRecognizer(target: self, action: #selector(navigateProfileImageEditView)))
        myProfileView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChanged), for: .editingChanged)
    }
    
    override func configNavigation() {
        navigationItem.title = viewModel.navigationTitle
        
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
                self.dismiss(animated: true) { [self] in
                    print("저장!!저장!!저장!!")
                    let profile = Profile(profileImage: myProfileView.profileImageView.selectedImage, nickname: myProfileView.nicknameTextField.text!)
                    completion?(profile)
                    viewModel.profile.value = profile
                }
            }),
            menu: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func navigateProfileImageEditView(_ sender: UITapGestureRecognizer) {
        let vc = MyProfileImageEditViewController()
        vc.selectedProfileImage = myProfileView.profileImageView.selectedImage
        vc.dismissCompletion = { [self] selectedImage in
            myProfileView.profileImageView.selectedImage = selectedImage
            viewModel.inputTextField.value = myProfileView.nicknameTextField.text
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func nicknameTextFieldDidChanged() {
        viewModel.inputTextField.value = myProfileView.nicknameTextField.text
    }
}
