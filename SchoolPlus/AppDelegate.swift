//
//  AppDelegate.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/9.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var tabBarController = MainTabViewController()
    var navigationController = UINavigationController()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }
    
    func setupWindow() {
           self.window = UIWindow(frame: UIScreen.main.bounds)
           self.window!.rootViewController = UINavigationController(rootViewController: LoginViewController())
           self.window!.makeKeyAndVisible()
       }

   

}

