//
//  MyProfileView.swift
//  SeanPedia
//
//  Created by BAE on 1/31/25.
//

import UIKit

import SnapKit
import Then

final class MyProfileView: BaseView {
    
    let profileCard = ProfileCard()
    let tableView = UITableView()
    let settingList = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func configHierarchy() {
        addSubview(profileCard)
        addSubview(tableView)
    }
    
    override func configLayout() {
        profileCard.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(screenHeight * 0.15)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileCard.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    override func configView() {
        tableView.layer.borderColor = UIColor.red.cgColor
        tableView.layer.borderWidth = 1
        
        tableView.do {
            $0.backgroundColor = .clear
        }
    }
    
    
}
