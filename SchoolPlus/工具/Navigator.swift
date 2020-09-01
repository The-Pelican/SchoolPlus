//
//  Navigator.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/9.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class Navigator {
    private static let shared = Navigator()
    
    static func window() -> UIWindow {
           return (UIApplication.shared.delegate as! AppDelegate).window ?? UIWindow()
    }
    
    static func tabBarContrller() -> MainTabViewController {
        return (UIApplication.shared.delegate as! AppDelegate).tabBarController
    }
    
    static func navigationController() -> UINavigationController {
        return (UIApplication.shared.delegate as! AppDelegate).navigationController
    }
    
    static func getViewController(key:String) -> UIViewController {
        shared.getViewController(key: key)
    }
    
}

extension Navigator {
    
    fileprivate func getViewController(key:String)-> UIViewController {
        let vc : UIViewController!
        switch key {
        case "注册":
            vc = RegisterViewController()
        case "登录":
            vc = LoginViewController()
        case "设置密码":
            vc = SetPasswordViewController()
        case "忘记密码":
            vc = ForgetPasswordViewController()
        case "认证":
            vc = AuthenticationViewController()
        case "校园":
            vc = SchoolPageViewController()
        case "组织":
            vc = GroupSearchViewController()
        case "信息":
            vc = CatalogueViewController()
        case"我的":
            vc = MyViewController()

        default:
            vc = LoginViewController()
        }
        return vc
    }
    
}
