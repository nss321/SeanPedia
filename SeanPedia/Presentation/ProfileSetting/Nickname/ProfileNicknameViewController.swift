//
//  ProfileViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

final class ProfileNicknameViewController: BaseViewController {
    
    let nicknameView = ProfileNicknameView()
    let viewModel = ProfileNicknameViewModel()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        viewModel.outputValidationText.bind { [weak self] string in
            self?.nicknameView.notiLabel.text = string
        }
        viewModel.outputIsValid.bind { [weak self] bool in
            self?.nicknameView.completeButton.isEnabled = bool
            self?.nicknameView.notiLabel.textColor = bool ? .seanPediaWhite : .seanPediaAccent
        }
        viewModel.outputCompleteButtonTapped.lazyBind { [weak self] _ in
            let vc = TabBarController()
            self?.navigationController?.pushNewRootController(root: vc)
        }
    }
    
    override func configView() {
        nicknameView.completeButton.configButtonInfo(title: "완료", action: UIAction(handler: { [weak self] _ in
            let profile = Profile(
                profileImage: (self?.nicknameView.profileImageView.selectedImage)!,
                nickname: (self?.nicknameView.nicknameTextField.text)!,
                signupDate: DateManager.shared.convertDateToString(date: Date.now))
            self?.viewModel.inputCompleteButtonTapped.value = profile
        }))
        
        nicknameView.profileImageView.changeAction(gesture: UITapGestureRecognizer(target: self, action: #selector(navigateProfileSettingView)))
        
        nicknameView.nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldDidChanged), for: .editingChanged)
    }
    
    override func configNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction(handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
        navigationItem.title = "프로필 설정"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    
    @objc private func nicknameTextFieldDidChanged() {
        viewModel.inputTextField.value = nicknameView.nicknameTextField.text
    }
}

extension ProfileNicknameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
