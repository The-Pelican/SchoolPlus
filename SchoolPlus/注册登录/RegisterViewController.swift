//
//  RegisterViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/9.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD
import RxSwift

class RegisterViewController: UIViewController {
    var idTextField = UITextField()
    var codeTextField = UITextField()
    var pwdTextField = UITextField()
    var repwdTextField = UITextField()
    var registerButton = UIButton()
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    func initSubView() {
        title = "账号注册"
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
        rightButton.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        codeTextField.rightView = rightButton
        
        pwdTextField.placeholder = "请输入密码"
        pwdTextField.borderStyle = .roundedRect
        pwdTextField.isSecureTextEntry = true
        self.view.addSubview(pwdTextField)
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
        
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(UIColor.black, for: .normal)
        registerButton.layer.borderWidth = 0.5
        registerButton.layer.cornerRadius = 20
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(45)
            $0.top.equalTo(repwdTextField.snp.bottom).offset(30)
            $0.height.equalTo(45)
        }
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getCode() {
        guard idTextField.text!.range(of: #"^1[3-9]\d{9}$"#,
                                      options: .regularExpression) != nil else {
                                        ProgressHUD.showFailed("电话号码不合法")
            return }
        user.regiAuthCode(id: idTextField.text!)
    }
    
    @objc func register() {
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
        guard codeTextField.text != nil else {return}
        guard let code = Int(codeTextField.text!) else {return}
        user.register(id: idTextField.text!, pwd: pwdTextField.text!, key: key, code: code).subscribe(onNext:{ string in
            user.save()
            ProgressHUD.showSuccess("注册成功")
            self.navigationController?.pushViewController(Navigator.getViewController(key: "认证"), animated: true)
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by:disposeBag)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        idTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
        repwdTextField.resignFirstResponder()
    }


}
