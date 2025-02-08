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
            self?.nicknameView.notiLabel.isHidden = string.isEmpty
            self?.nicknameView.notiLabel.text = string
        }
        viewModel.outputIsValid.bind { [weak self] bool in
            guard let mbtiCounter = self?.viewModel.mbtiCounter else { return }
            self?.nicknameView.completeButton.isEnabled = bool && mbtiCounter.allSatisfy({ $0 })
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
    }
    
    override func configDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        nicknameView.mbtiCollectionViewStack.arrangedSubviews.forEach {
            ($0 as? UICollectionView)?.delegate = self
            ($0 as? UICollectionView)?.dataSource = self
        }
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

extension ProfileNicknameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.id, for: indexPath) as! MBTICollectionViewCell
        
        switch collectionView.tag {
        case 0:
            cell.config(char: viewModel.energyOrientation[index])
            print(#function, viewModel.energyOrientation[index])
        case 1:
            cell.config(char: viewModel.informationProcessing[index])
        case 2:
            cell.config(char: viewModel.decisionMaking[index])
        case 3:
            cell.config(char: viewModel.lifestyleApproach[index])
        default:
            print("")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MBTICollectionViewCell else {
            return true
        }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: false)
            viewModel.mbtiCounter[collectionView.tag] = false
            viewModel.inputCheckValidation.value = ()
            return false
        } else {
            viewModel.mbtiCounter[collectionView.tag] = true
            switch collectionView.tag {
            case 0:
                viewModel.currentMBTI[collectionView.tag] = viewModel.energyOrientation[indexPath.item]
            case 1:
                viewModel.currentMBTI[collectionView.tag] = viewModel.informationProcessing[indexPath.item]
            case 2:
                viewModel.currentMBTI[collectionView.tag] = viewModel.decisionMaking[indexPath.item]
            case 3:
                viewModel.currentMBTI[collectionView.tag] = viewModel.lifestyleApproach[indexPath.item]
            default:
                print("")
            }
            viewModel.inputCheckValidation.value = ()
            return true
        }
    }
}

extension ProfileNicknameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
