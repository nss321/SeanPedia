//
//  OnboardingView.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import SnapKit
import Then

final class OnboardingView: BaseView {
    private let imageView = UIImageView()
    private let onboardingLabel = UILabel()
    private let onboardingSubLabel = UILabel()
    private let startButton = CustomCTAButton()
    
    override func configHierarchy() {
        [imageView, onboardingLabel, onboardingSubLabel, startButton].forEach { addSubview($0) }
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(onboardingLabel.snp.top)
        }
        onboardingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.3)
        }
        onboardingSubLabel.snp.makeConstraints {
            $0.top.equalTo(onboardingLabel.snp.bottom).offset(baseMargin * 2)
            $0.centerX.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(onboardingSubLabel.snp.bottom).offset(baseMargin * 2)
            $0.horizontalEdges.equalToSuperview().inset(baseMargin)
            $0.height.equalTo(36)
        }
    }
    
    override func configView() {
        imageView.do {
            $0.image = UIImage(named: "onboarding")
            $0.contentMode = .scaleToFill
        }
        onboardingLabel.do {
            $0.text = "Onboarding"
            $0.font = .italicSystemFont(ofSize: 32)
            $0.textColor = .seanPediaWhite
        }
        onboardingSubLabel.do {
            $0.text = """
                    당신만의 영화 세상,
                    SeanPedia를 시작해보세요.
                    """
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 17)
            $0.textColor = .seanPediaWhite
            $0.numberOfLines = 0
        }
        startButton.configButtonInfo(title: "시작하기", action: UIAction(handler: { UIAction in
            print(#function)
        }))
    }
}
