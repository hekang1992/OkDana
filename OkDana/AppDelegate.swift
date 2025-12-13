//
//  AppDelegate.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var tabBar: BaseTabBarController = {
        let tabBar = BaseTabBarController()
        return tabBar
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        return true
    }


}

