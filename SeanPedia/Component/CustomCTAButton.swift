//
//  CustomCTAButton.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import SnapKit
import Then

final class CustomCTAButton: UIButton {
    private var config = UIButton.Configuration.plain()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configStaticButtonStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configStaticButtonStyle() {
        config.background.backgroundColor = .seanPediaBlack
        config.cornerStyle = .capsule
        config.baseForegroundColor = .seanPediaAccent
        config.background.strokeColor = .seanPediaAccent
        config.background.strokeWidth = 1
        configuration = config
        
        self.snp.makeConstraints { $0.height.equalTo(36) }
    }
    
    func configButtonInfo(title: String, action: UIAction) {
        //        config.attributedTitle
        config.title = title
        addAction(action, for: .touchUpInside)
        configuration = config
    }
}
