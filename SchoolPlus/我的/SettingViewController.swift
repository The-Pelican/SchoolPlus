//
//  SettingViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/27.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    let logoutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()

        
    }
    
    func initSubView() {
        title = "设置"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        
        
    }
    
    func logout() {
        UIAlertController.showConfirm(message: "确定退出登陆？", in: self, confirm: { action in
            user.logout()
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            Navigator.window().rootViewController = navigationController
        })
    }
    


}
