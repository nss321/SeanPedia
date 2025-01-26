//
//  OnboardingViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    
    private let onboardingView = OnboardingView()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func configHierarchy() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        onboardingView.startButton.configButtonInfo(title: "시작하기", action: UIAction(handler: { UIAction in
            let vc = ProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }))
    }
}
