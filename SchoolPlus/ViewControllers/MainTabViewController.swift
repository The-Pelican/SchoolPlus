//
//  MainTabViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/17.
//  Copyright © 2020 金含霖. All rights reserved.
//


import UIKit
import RxSwift

class MainTabViewController: UITabBarController {
    let model =  InfoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    func initControllers() {
        //let school = Navigator.getViewController(key: "校园")
        let group = Navigator.getViewController(key: "组织")
        let info = Navigator.getViewController(key: "信息")
        let my = Navigator.getViewController(key: "我的")
        let page = PageViewController()
        let auth = EndAMViewController()
        
        let schoolItem = UITabBarItem(title: "学院", image: UIImage(named: "底部icon_学院"), tag: 0)
        let groupItem = UITabBarItem(title: "组织", image: UIImage(named: "底部社团_icon"), tag: 1)
        let infoItem = UITabBarItem(title: "信息", image: UIImage(named: "底部icon_消息"), tag: 2)
        let myItem = UITabBarItem(title: "我的", image: UIImage(named: "底部icon_我的"), tag: 3)
        
        page.tabBarItem = schoolItem
        group.tabBarItem = groupItem
        info.tabBarItem = infoItem
        my.tabBarItem = myItem
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.white
        
        let viewControllers = [page,group,info,my]
        self.setViewControllers(viewControllers, animated: false)
        self.selectedIndex = 1
        
        model.unread().subscribe(onNext: { string in
            infoItem.badgeValue = string
        },onError: { error in
            
            }).disposed(by: disposeBag)
    }
}
