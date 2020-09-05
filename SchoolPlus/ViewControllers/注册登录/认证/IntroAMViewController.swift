//
//  IntroAMViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
class IntroAMViewController: UIViewController {
    
    let nameLabel = UILabel()
    let introLabel = UILabel()
    let nextButton = UIButton()
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func initSubView() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.text = "个人认证"
        nameLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(100)
            $0.top.equalTo(44)
        })
        
        self.view.addSubview(introLabel)
        introLabel.textAlignment = .center
        introLabel.numberOfLines = 2
        introLabel.text = """
        这是一个实名制社区
        接下来只需要一步小小的认证
        """
        introLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.height.equalTo(200)
            $0.width.equalTo(300)
        })
        
        self.view.addSubview(nextButton)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.backgroundColor = UIColor.systemBlue
        nextButton.layer.cornerRadius = 5
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(100)
            $0.top.equalTo(introLabel.snp.bottom).offset(30)
        })
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        
        self.view.addSubview(backButton)
        backButton.setTitle("退出", for: .normal)
        backButton.setTitleColor(UIColor.systemBlue, for: .normal)
        backButton.snp.makeConstraints({
            $0.height.equalTo(40)
            $0.width.equalTo(50)
            $0.top.equalTo(nameLabel.snp.top)
            $0.right.equalToSuperview().offset(-28)
        })
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        
    }
    
    @objc func back() {
        UIAlertController.showConfirm(message: "确定要退出认证吗？", in: self, confirm: { [weak self]action in
            print("点击了确定")
            self?.navigationController?.popToViewController(LoginViewController(), animated: true)
        })
    }
    
    @objc func nextStep() {
        self.navigationController?.pushViewController(AuthenticationViewController(), animated: true)
    }
}
