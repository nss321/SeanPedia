//
//  AppDelegate.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BaseView.appearance().backgroundColor = .seanPediaBlack
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .seanPediaBlack
        appearance.titleTextAttributes = [.foregroundColor : UIColor.seanPediaWhite]

        UINavigationBar.appearance().tintColor = .seanPediaAccent
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        UITabBar.appearance().tintColor = .seanPediaAccent
        
        // TODO: Default 2s
        Thread.sleep(forTimeInterval: 0.5)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        NotificationCenter.default.post(
            name: Notification.Name("test"),
            object: nil,
            userInfo: [
                "terminate" : true
            ])
    }

}

