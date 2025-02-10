//
//  ProfileNicknameViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/8/25.
//

import Foundation

final class ProfileNicknameViewModel: BaseViewModel {
    let energyOrientation = ["E","I"]
    let informationProcessing = ["S","N"]
    let decisionMaking = ["F","T"]
    let lifestyleApproach = ["P","J"]
    var mbtiCounter = Array(repeating: false, count: 4)
    var currentMBTI = Array(repeating: "", count: 4)
    
    struct Input {
        let textField: Observable<String?> = .init(nil)
        let completeButtonTapped: Observable<Profile?> = .init(nil)
        let checkValidation: Observable<Void?> = .init(())
    }
    
    struct Output {
        let validationText = Observable("")
        let isValid = Observable(false)
        let completeButtonTapped: Observable<Void?> = .init(nil)
    }
    
    let input: Input
    let output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.textField.bind { [weak self] _ in
            self?.checkValidaiton()
        }
        input.completeButtonTapped.lazyBind { [weak self] profile in
            self?.completeButtonTapped(profile: profile)
        }
        input.checkValidation.lazyBind { [weak self] _ in
            print(#function, "셀 클릭")
            self?.checkValidaiton()
        }
    }
     
    private func completeButtonTapped(profile: Profile?) {
        if let profile {
            UserDefaultsManager.shared.setData(kind: .profile, type: Profile.self, data: profile)
            UserDefaultsManager.shared.isOnboarded = true
            UserDefaultsManager.shared.mbti = currentMBTI.joined()
            output.completeButtonTapped.value = ()
        } else {
            print(#function, "unexpected nil")
            fatalError()
        }
    }
    
    private func checkValidaiton() {
        print(#function)
        guard let nickname = input.textField.value else {
            output.validationText.value = ""
            output.isValid.value = false
            return
        }
        
        if nickname.isEmpty {
            output.validationText.value = ""
            return
        }
        
        if nickname.count < 2 || nickname.count > 10 {
            output.validationText.value = "2글자 이상 10글자 미만으로 설정해주세요"
            output.isValid.value = false
            return
        }
        if nickname.contains(/[@#$%]/) {
            output.validationText.value = "닉네임에 @,#,$,%는 포함할 수 없어요."
            output.isValid.value = false
            return
        }
        if nickname.contains(/\d/) {
            output.validationText.value = "닉네임에 숫자는 포함할 수 없어요."
            output.isValid.value = false
            return
        } else {
            output.validationText.value = "사용할 수 있는 닉네임이에요."
            output.isValid.value = true
            return
        }
    }
}
