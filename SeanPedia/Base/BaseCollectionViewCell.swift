//
//  BaseCollectionViewCell.swift
//  SeanPedia
//
//  Created by BAE on 1/29/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configHierarchy()
        configLayout()
        configView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        
    }
    
}
