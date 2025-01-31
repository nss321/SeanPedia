//
//  TabBarController.swift
//  SeanPedia
//
//  Created by BAE on 1/27/25.
//

import UIKit

import SnapKit
import Then

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        setupTabbarAppearance()
    }
    
    func configTabBar() {
        let firstVC = UINavigationController(rootViewController: MainViewController())
        firstVC.tabBarItem.image = UIImage(systemName: "popcorn")
        
        let secondVC = UINavigationController(rootViewController: UpcomingViewController())
        secondVC.tabBarItem.image = UIImage(systemName: "film.stack")
        
        let thirdVC = UINavigationController(rootViewController: MyProfileViewController())
        thirdVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }

    func setupTabbarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .seanPediaBlack
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
}
