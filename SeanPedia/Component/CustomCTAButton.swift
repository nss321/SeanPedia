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
        
        self.snp.makeConstraints { $0.height.equalTo(40) }
        
        configurationUpdateHandler = { [weak self] button in
            switch button.state {
            case .disabled:
                self?.configuration?.background.strokeColor = .seanPediaGray
                self?.configuration?.baseForegroundColor = .seanPediaGray
            case .normal:
                self?.configuration?.background.strokeColor = .seanPediaAccent
                self?.configuration?.baseForegroundColor = .seanPediaAccent
            default:
                self?.configuration?.background.backgroundColor = .seanPediaBlack
                self?.configuration?.background.strokeWidth = 1
            }
        }
        
    }
    
    func configButtonInfo(title: String, action: UIAction) {
        config.title = title
        addAction(action, for: .touchUpInside)
        configuration = config
    }
}
