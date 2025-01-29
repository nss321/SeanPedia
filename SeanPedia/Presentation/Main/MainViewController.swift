//
//  MainViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

final class MainViewController: BaseViewController {
    
    let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    
    override func configHierarchy() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        mainView.setGestureToProfileContainer(gesture: UITapGestureRecognizer(target: self, action: #selector(presentProfileSettingViewController)))
        
    }
    
    override func configDelegate() {
        
    }
    
    override func configNavigation() {
        navigationItem.title = "오늘의 영화"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            primaryAction: UIAction(handler: { _ in
//                guard let completion = self.dismissCompletion, let selectedImage = self.profileImageSettingView.selectedImage else { fatalError() }
//                completion(selectedImage)
//                
                let vc = SearchViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            menu: nil)
    }
    
    @objc private func presentProfileSettingViewController() {
        let vc = UINavigationController(rootViewController: MyProfileViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
