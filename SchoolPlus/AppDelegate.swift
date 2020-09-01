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
        
        if user.pho != "" && user.pwd != "" {
            print("已经有账号")
            user.getMyMessage().subscribe(onNext:{ [weak self]string in
                if string == "success" {
                    print(user.userId)
                    self?.backgroundLogin()
                }
                if string == "token过期" {
                    user.updateToken(aT: user.accessToken, rT: user.refreshToken)
                }
            })
        }
        return true
    }
    
    func setupWindow() {
           self.window = UIWindow(frame: UIScreen.main.bounds)
           self.window!.rootViewController = UINavigationController(rootViewController: LoginViewController())
           self.window!.makeKeyAndVisible()
       }
    
    func backgroundLogin() {
        tabBarController = MainTabViewController()
        self.tabBarController.initControllers()
        var navigationController = UINavigationController(rootViewController: self.tabBarController)
        if user.hasChecked == false {
            navigationController = UINavigationController(rootViewController: AuthenticationViewController())
        }
            self.window!.rootViewController = navigationController
    }
    
}

