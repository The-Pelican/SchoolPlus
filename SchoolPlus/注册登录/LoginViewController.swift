//
//  LoginViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/9.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import SnapKit
import ProgressHUD
import RxSwift

class LoginViewController: UIViewController {
     var nameLabel = UILabel()
     var idTextField = UITextField()
     var pwdTextField = UITextField()
     var codeTextField = UITextField()
     var chooseButton = UIButton()
     var forgetButton = UIButton()
     var registerButton = UIButton()
     var loginButton = UIButton()
     let disposeBag = DisposeBag()
    
     var isCode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(true, animated: true)
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
       
    
    func initSubView() {
        nameLabel.text = "\"校园+\"登录"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(300)
            $0.top.equalToSuperview().offset(200)
        }
        
        idTextField.placeholder = "请输入手机号"
        idTextField.borderStyle = .roundedRect
        self.view.addSubview(idTextField)
        idTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(45)
            $0.left.equalToSuperview().offset(28)
            $0.height.equalTo(55)
        }
        
        pwdTextField.placeholder = "请输入密码"
        pwdTextField.borderStyle = .roundedRect
        pwdTextField.isSecureTextEntry = true
        self.view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(28)
            $0.height.equalTo(55)
        }
        
        codeTextField.placeholder = "请输入验证码"
        codeTextField.borderStyle = .roundedRect
        self.view.addSubview(codeTextField)
        codeTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(28)
            $0.height.equalTo(55)
        }
        codeTextField.rightViewMode = .always
        let rightButton = TimerButton()
        rightButton.frame = CGRect(x:0, y:0, width: 60, height: 35)
        rightButton.setTitle("获取验证码", for: .normal)
        rightButton.setTitleColor(UIColor.black, for: .normal)
        rightButton.layer.borderWidth = 0.5
        rightButton.layer.cornerRadius = 8.0
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        rightButton.backgroundColor = UIColor.black
        rightButton.setTitleColor(UIColor(valueStr: "FBEA77"), for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        rightButton.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        codeTextField.rightView = rightButton
        codeTextField.isHidden = true
        
        forgetButton.setTitle("忘记密码？", for: .normal)
        forgetButton.setTitleColor(UIColor.black, for: .normal)
        forgetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        forgetButton.addTarget(self, action: #selector(forget), for: .touchUpInside)
        self.view.addSubview(forgetButton)
        forgetButton.snp.makeConstraints {
             $0.right.equalTo(idTextField.snp.right).offset(15)
             $0.height.equalTo(50)
             $0.width.equalTo(100)
             $0.top.equalTo(idTextField.snp.bottom).offset(95)
        }
        forgetButton.isHidden = false
               
        registerButton.setTitle("还未注册？", for: .normal)
        registerButton.setTitleColor(UIColor.black, for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints {
              $0.left.equalTo(idTextField.snp.left).offset(-5)
              $0.height.equalTo(50)
              $0.width.equalTo(100)
              $0.top.equalTo(idTextField.snp.bottom).offset(95)
        }
               
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.layer.borderWidth = 0.5
        loginButton.layer.cornerRadius = 8
        loginButton.layer.shadowOffset = CGSize(width: 1,height: 1)
        loginButton.layer.shadowOpacity = 0.8
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.backgroundColor = UIColor(valueStr: "FBEA77")
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
              $0.centerX.equalToSuperview()
              $0.left.equalToSuperview().offset(100)
              $0.top.equalTo(forgetButton.snp.bottom).offset(50)
              $0.height.equalTo(50)
        }
               
         chooseButton.setTitle("账号密码登录", for: .normal)
         chooseButton.setTitleColor(UIColor.lightGray, for: .normal)
         chooseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
         chooseButton.addTarget(self, action: #selector(choose), for: .touchUpInside)
         self.view.addSubview(chooseButton)
         chooseButton.snp.makeConstraints {
               $0.centerX.equalToSuperview()
               $0.left.equalTo(loginButton.snp.left).offset(5)
               $0.bottom.equalTo(loginButton.snp.top).offset(3)
        }
    }
    
//    MARK:-注册登录
    
    
    @objc func register() {
        self.navigationController?.pushViewController(Navigator.getViewController(key:"注册"), animated: true)
    }
    
    @objc func forget() {
        self.navigationController?.pushViewController(Navigator.getViewController(key: "忘记密码"), animated: true)
    }
   
    
    @objc func choose() {
        isCode = !isCode
        if isCode {
            pwdTextField.isHidden = true
            codeTextField.isHidden = false
            forgetButton.isHidden = true
            chooseButton.setTitle("账号密码登录", for: .normal)
        } else {
            codeTextField.isHidden = true
            pwdTextField.isHidden = false
            forgetButton.isHidden = false
            chooseButton.setTitle("手机验证码登录", for: .normal)
        }
    }
    
    @objc func getCode() {
        guard idTextField.text!.range(of: #"^1[3-9]\d{9}$"#,
                                      options: .regularExpression) != nil else {
                                        ProgressHUD.showFailed("电话号码不合法")
            return }
        user.loginAuthCode(pho: idTextField.text!)
    }
    
    @objc func login() {
        guard idTextField.text!.range(of: #"^1[3-9]\d{9}$"#,
                                      options: .regularExpression) != nil else {
                                        ProgressHUD.showFailed("电话号码不合法")
            return }
        if isCode {
            guard let intCode = Int(codeTextField.text!) else {return}
            user.codeLogin(pho: idTextField.text!,key:key,code: intCode ).subscribe(onNext: { string in
                if string == "unfinished" {
                    print(user.pho)
                    let vc = SetPasswordViewController()
                    vc.code = intCode
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if string == "finished" {
                    print(user.refreshToken)
                    user.loginType = .logined
                    user.save()
                    user.getMyMessage()
                    let tabController = MainTabViewController()
                    tabController.initControllers()
                    let navigationController = UINavigationController(rootViewController: tabController)
                    Navigator.window().rootViewController = navigationController
                }
            },onError: {error in
                ProgressHUD.showError(error.localizedDescription)
                
                }).disposed(by: disposeBag)
        } else {
            user.pwdLogin(pho: idTextField.text!, pwd: pwdTextField.text!).subscribe(onNext:{ string in
                user.getMyMessage().subscribe(onNext:{
                    string in
                    guard string == "success" else {
                        ProgressHUD.show(string)
                        return
                    }
                    user.loginType = .logined
                    user.save()
                    user.saveInfo()
                    ProgressHUD.showSucceed()
                    let tabController = MainTabViewController()
                    tabController.initControllers()
                    let navigationController = UINavigationController(rootViewController: tabController)
                    Navigator.window().rootViewController = navigationController
                })
            },onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by:disposeBag)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        idTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }



}
