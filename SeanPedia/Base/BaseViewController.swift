//
//  BaseViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

import SnapKit
import Then

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configHierarchy()
        configLayout()
        configView()
        configDelegate()
        configNavigation()
    }
    
    func bind() {
        
    }
    
    func configHierarchy() {
        
    }
    
    func configLayout() {
        
    }
    
    func configView() {
        view.backgroundColor = .seanPediaBlack
    }
    
    func configDelegate() {
        
    }
    
    func configNavigation() {

    }
    
}
