//
//  ProfileImageSettingViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/10/25.
//

import Foundation

final class ProfileImageSettingViewModel {
    var lastSelected: IndexPath?
    var selectedProfileImage: String?
    var dismissCompletion: ((String) -> Void)?
    
    let inputSelectedImage: Observable<String?> = .init(nil)
    let outputSelectedImage: Observable<String?> = .init(nil)
    
    init() {
        inputSelectedImage.bind { [weak self] selectedImageName in
            self?.outputSelectedImage.value = selectedImageName
        }
    }
}
