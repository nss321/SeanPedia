//
//  MyProfileViewController.swift
//  SeanPedia
//
//  Created by BAE on 1/30/25.
//

import UIKit

final class MyProfileViewController: BaseViewController {
    
    private let myProfileView = MyProfileView()
    
    override func loadView() {
        view = myProfileView
    }
    
    override func configHierarchy() {
        
    }
    
    override func configLayout() {
        
    }
    
    override func configView() {
        myProfileView.profileCard.setGestureToProfileContainer(gesture: UITapGestureRecognizer(target: self, action: #selector(presentProfileSettingViewController)))
        
    }
    
    override func configDelegate() {
//        myProfileView.tableView.dataSource = self
//        myProfileView.tableView.delegate = self
        
    }
    
    override func configNavigation() {
        navigationItem.title = "설정"
    
    }
    @objc private func presentProfileSettingViewController() {
        print(#function)
        let vc = UINavigationController(rootViewController: MyProfileEditViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
//
//extension MyProfileViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myProfileView.settingList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let row = myProfileView.settingList[indexPath.row]
//        
//    }
//    
//    
//}
