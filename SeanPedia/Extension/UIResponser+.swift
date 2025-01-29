//
//  UIResponser.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

extension UIResponder {
    
    /// 12
    var smallMargin: Int {
        12
    }

    /// 16
    var mediumMargin: Int {
        16
    }
    
    /// 20
    var largeMargin: Int {
        20
    }
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    var profileImageCollectionViewDiemeter: Int {
        (Int(screenWidth) - largeMargin * 2 - smallMargin * 3) / 4
    }
    
    
}
