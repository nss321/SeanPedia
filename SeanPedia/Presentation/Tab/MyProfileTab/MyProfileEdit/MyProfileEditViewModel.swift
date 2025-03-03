//
//  MyProfileEditViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/5/25.
//

import Foundation

final class MyProfileEditViewModel {
    let navigationTitle = "프로필 편집"
    
    let inputTextField: CustomObservable<String?> = CustomObservable(nil)
    let outputValidationText = CustomObservable("")
    let outputIsValid = CustomObservable(false)
    
    let profile: CustomObservable<Profile?> = CustomObservable(nil)
    let inputSaveButtonTapped: CustomObservable<Void> = CustomObservable(())
    
    init() {
        inputTextField.bind { [weak self] _ in
            self?.checkValidaiton()
        }
        profile.bind { [weak self] _ in
            self?.saveChangedProfile()
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
    
    private func saveChangedProfile() {
        guard let newValue = profile.value else {
            print(#function, "can not unwrapping new profile")
            return
        }
        
        let signupDate = UserDefaultsManager.shared.getStoredData(kind: .profile, type: Profile.self)?.signupDate
        
        guard let signupDate else {
            let newProfile = Profile(profileImage: newValue.profileImage, nickname: newValue.nickname, signupDate: DateManager.shared.convertDateToString(date: Date.now))
            UserDefaultsManager.shared.setData(kind: .profile, type: Profile.self, data: newProfile)
            print(#function, "can not unwrapping signup date. but don't worry! new profile saved anyway :)")
            return
        }
        
        let newProfile = Profile(profileImage: newValue.profileImage, nickname: newValue.nickname, signupDate: signupDate)
        UserDefaultsManager.shared.setData(kind: .profile, type: Profile.self, data: newProfile)
        print(#function, "new profile successfully saved")
        dump(UserDefaultsManager.shared.getStoredData(kind: .profile, type: Profile.self))
    }
}
