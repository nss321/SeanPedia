//
//  ProfileImageSettingViewModel.swift
//  SeanPedia
//
//  Created by BAE on 2/10/25.
//

import Foundation

final class ProfileImageSettingViewModel: BaseViewModel {
    
    var lastSelected: IndexPath?
    var selectedProfileImage: String?
    var dismissCompletion: ((String) -> Void)?
    
    struct Input {
        let selectedImage: Observable<String?> = .init(nil)
    }
    
    struct Output {
        let selectedImage: Observable<String?> = .init(nil)
    }
    
    let input: Input
    let output: Output
    
    init() {
        input = Input()
        output = Output()
        transform()
    }
    
    func transform() {
        input.selectedImage.bind { [weak self] selectedImageName in
            self?.output.selectedImage.value = selectedImageName
        }
    }
}
