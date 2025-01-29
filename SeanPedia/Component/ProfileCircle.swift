//
//  ProfileSelect.swift
//  SeanPedia
//
//  Created by BAE on 1/26/25.
//

import UIKit

import SnapKit
import Then

final class ProfileCircle: BaseView {
    
    private let isRepresented: Bool
    private let diemeter: Int
    private var isSelected: Bool {
        didSet {
            reloadProfileCircle(state: isSelected)
        }
    }
    
    private var imageView = UIImageView()
    private let cameraSymbol = UIImageView()
    
    private var _selectedImage: String?
    
    var selectedImage: String {
        get {
            guard let _selectedImage else {
                print(#function, "no image")
                return "profile_0"
            }
            return _selectedImage
        }
        set {
            _selectedImage = newValue
            imageView.image = UIImage(named: newValue)
        }
    }
    
    /*
     1. stored prop이 모두 초기화 되어 있고, 별도의 init이 없다면 부모의 init을 상속 받음.
     2. 부모의 init을 상속 받거나, 부모의 init을 모두 구현한다면, 부모의 모든 convenience init도 상속 받음
     */

    init(isRepresented: Bool, diemeter: Int, isSelected: Bool = false) {
        self.isRepresented = isRepresented
        self.diemeter = diemeter
        self.isSelected = isSelected
        super.init(frame: .zero)
    }
    
    override func configHierarchy() {
        [imageView, cameraSymbol].forEach { addSubview($0) }
    }
    
    override func configLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(diemeter)
        }
        
        cameraSymbol.snp.makeConstraints {
            $0.trailing.bottom.equalTo(imageView)
            $0.size.equalTo(diemeter / 3)
        }
        
    }
    
    override func configView() {
        if isRepresented {
            isSelected = true
        } else {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circleTapped)))
        }
    
        isUserInteractionEnabled = true
        alpha = isSelected ? 1.0 : 0.5
        
        imageView.do {
            $0.image = UIImage(named: selectedImage)
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CGFloat(diemeter / 2)
            $0.layer.borderColor = isSelected ? UIColor.seanPediaAccent.cgColor : UIColor.seanPediaGray.cgColor
            $0.layer.borderWidth = isSelected ? 3 : 1
        }
        
        cameraSymbol.do {
            let config = UIImage.SymbolConfiguration.init(paletteColors: [.seanPediaWhite, isSelected ? .seanPediaAccent : .seanPediaGray])
            $0.image = UIImage(systemName: "camera.circle.fill")?.applyingSymbolConfiguration(config)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = CGFloat(diemeter / 6)
            $0.isHidden = isRepresented ? false : true
        }
        
    }

    @objc private func circleTapped() {
        print(#function, self)
        selectStateToggle()
    }
    
    func selectStateToggle() {
        self.isSelected.toggle()
    }
    
    func changeAction(gesture: UITapGestureRecognizer) {
        gestureRecognizers?.removeAll()
        addGestureRecognizer(gesture)
    }
    
    private func reloadProfileCircle(state: Bool) {
        if state {
            self.imageView.layer.borderWidth = 3
            self.imageView.layer.borderColor = UIColor.seanPediaAccent.cgColor
            self.cameraSymbol.image = UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(paletteColors: [.seanPediaWhite, .seanPediaAccent]))
            self.alpha = 1.0
        } else {
            self.imageView.layer.borderWidth = 1
            self.imageView.layer.borderColor = UIColor.seanPediaGray.cgColor
            self.cameraSymbol.image = UIImage(systemName: "camera.circle.fill", withConfiguration: UIImage.SymbolConfiguration.init(paletteColors: [.seanPediaWhite, .seanPediaGray]))
            self.alpha = 0.5
        }
    }
    
    func configImage(image: String) {
        selectedImage = image
        if let uiimage = UIImage(named: image) {
            self.imageView.image = uiimage
        } else {
            self.imageView.image = UIImage(systemName: "xmark")
        }
        gestureRecognizers?.removeAll()
    }
    
}
