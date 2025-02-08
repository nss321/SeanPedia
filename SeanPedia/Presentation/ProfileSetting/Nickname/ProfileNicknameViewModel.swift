//
//  ProfileNicknameViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/8/25.
//

import Foundation

final class ProfileNicknameViewModel {
    let inputTextField: Observable<String?> = Observable(nil)
    let outputValidationText = Observable("")
    let outputIsValid = Observable(false)

    let inputCompleteButtonTapped: Observable<Profile?> = Observable(nil)
    let outputCompleteButtonTapped: Observable<Void?> = Observable(nil)
    
    init() {
        print(#function, "profilenicknameviewmodel init")
        inputTextField.bind { [weak self] _ in
            self?.checkValidaiton()
        }
        inputCompleteButtonTapped.lazyBind { [weak self] profile in
            self?.completeButtonTapped(profile: profile)
        }
    }
     
    private func completeButtonTapped(profile: Profile?) {
        if let profile {
            UserDefaultsManager.shared.setData(kind: .profile, type: Profile.self, data: profile)
            UserDefaultsManager.shared.isOnboarded = true
            outputCompleteButtonTapped.value = ()
        } else {
            print(#function, "unexpected nil")
            fatalError()
        }
    }
    
    private func checkValidaiton() {
        print(#function)
        guard let nickname = inputTextField.value else {
            outputValidationText.value = ""
            outputIsValid.value = false
            return
        }
        
        if nickname.count < 2 || nickname.count > 10 {
            outputValidationText.value = "2글자 이상 10글자 미만으로 설정해주세요"
            outputIsValid.value = false
            return
        }
        if nickname.contains(/[@#$%]/) {
            outputValidationText.value = "닉네임에 @,#,$,%는 포함할 수 없어요."
            outputIsValid.value = false
            return
        }
        if nickname.contains(/\d/) {
            outputValidationText.value = "닉네임에 숫자는 포함할 수 없어요."
            outputIsValid.value = false
            return
        } else {
            outputValidationText.value = "사용할 수 있는 닉네임이에요."
            outputIsValid.value = true
            return
        }
    }
}
