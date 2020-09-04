//
//  EndAMViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class EndAMViewController: UIViewController {
    var label = UILabel()
    var button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func initSubView() {
        self.view.backgroundColor = UIColor.white
        label.numberOfLines = 3
        label.text = "认证审核时间为1-2个工作日\n此期间您可以浏览社区部分内容\n个人认证成功之后即可解锁社区所有功能"
        label.textAlignment = .center
        self.view.addSubview(label)
        label.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().offset(28)
            $0.height.equalTo(200)
        })
        
        button.setTitle("开启游客模式", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(30)
            $0.height.equalTo(50)
        })
    }
    
    @objc func start() {
        let tabController = MainTabViewController()
        tabController.initControllers()
        let navigationController = UINavigationController(rootViewController: tabController)
        Navigator.window().rootViewController = navigationController
    }



}
