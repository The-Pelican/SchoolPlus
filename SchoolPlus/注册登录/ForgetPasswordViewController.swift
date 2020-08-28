//
//  ForgetPasswordViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/11.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD

class ForgetPasswordViewController: UIViewController {
    var idTextField = UITextField()
    var codeTextField = UITextField()
    var pwdTextField = UITextField()
    var repwdTextField = UITextField()
    var Button = UIButton()

        override func viewDidLoad() {
            super.viewDidLoad()
            initSubView()
        }
        
        func initSubView() {
             title = "忘记密码"
             self.view.backgroundColor = UIColor.white
             self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
             self.navigationController?.navigationBar.shadowImage = UIImage()
            
            
            idTextField.placeholder = "请输入手机号"
            idTextField.borderStyle = .roundedRect
            self.view.addSubview(idTextField)
            idTextField.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(150)
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
            rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            rightButton.addTarget(self, action: #selector(getCode), for: .touchUpInside)
            codeTextField.rightView = rightButton
            
            pwdTextField.placeholder = "请输入密码"
            pwdTextField.borderStyle = .roundedRect
            self.view.addSubview(pwdTextField)
            pwdTextField.isSecureTextEntry = true
            pwdTextField.snp.makeConstraints {
                       $0.centerX.equalToSuperview()
                       $0.top.equalTo(codeTextField.snp.bottom).offset(30)
                       $0.left.equalToSuperview().offset(28)
                       $0.height.equalTo(55)
                   }
            
            repwdTextField.placeholder = "请再次输入密码"
            repwdTextField.borderStyle = .roundedRect
            repwdTextField.isSecureTextEntry = true
                   self.view.addSubview(repwdTextField)
                   repwdTextField.snp.makeConstraints {
                       $0.centerX.equalToSuperview()
                       $0.top.equalTo(pwdTextField.snp.bottom).offset(30)
                       $0.left.equalToSuperview().offset(28)
                       $0.height.equalTo(55)
                   }
            
            Button.setTitle("完成", for: .normal)
            Button.setTitleColor(UIColor.black, for: .normal)
            Button.layer.borderWidth = 0.5
            Button.layer.cornerRadius = 20
            Button.layer.shadowOffset = CGSize(width: 1,height: 1)
            Button.layer.shadowOpacity = 0.8
            Button.layer.shadowColor = UIColor.black.cgColor
            Button.addTarget(self, action: #selector(done), for: .touchUpInside)
            self.view.addSubview(Button)
            Button.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(45)
                $0.top.equalTo(repwdTextField.snp.bottom).offset(30)
                $0.height.equalTo(45)
            }
        }
        
    
    
    @objc func getCode() {
        guard idTextField.text!.range(of: #"^1[3-9]\d{9}$"#,
                                      options: .regularExpression) != nil else {
                                        ProgressHUD.showFailed("电话号码不合法")
            return }
        user.regiAuthCode(id: idTextField.text!)
    }
        
    @objc func done() {
        guard idTextField.text!.range(of: #"^1[3-9]\d{9}$"#,
                                      options: .regularExpression) != nil else {
                                        ProgressHUD.showFailed("电话号码不合法")
            return }
        guard pwdTextField.text!.range(of: #"^(?!\d+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)])+$)[0-9a-zA-Z\-/:;()$&@".,?!'\[\]{}#%^*+=_\\|~<>]{8,14}$"#, options: .regularExpression) != nil else {
            ProgressHUD.showFailed("密码不合法")
            return }
        guard pwdTextField.text == repwdTextField.text else {
            ProgressHUD.showFailed("两次密码不一致")
            return}
        guard let code = Int(codeTextField.text!) else {return}
        user.refreshPW(id: idTextField.text!, key: key, code: code, pwd: pwdTextField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        idTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        repwdTextField.resignFirstResponder()
    }






}
