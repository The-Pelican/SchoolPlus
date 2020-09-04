//
//  SetPasswordViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/11.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD
import RxSwift

class SetPasswordViewController: UIViewController {
    var pwdTextField = UITextField()
    var repwdTextField = UITextField()
    var nextButton = UIButton()
    let disponseBag = DisposeBag()
    var code = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    func initSubView() {
         title = "设置密码"
         self.view.backgroundColor = UIColor.white
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        pwdTextField.placeholder = "请输入密码"
        pwdTextField.isSecureTextEntry = true
        pwdTextField.borderStyle = .roundedRect
        self.view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(150)
            $0.left.equalTo(28)
            $0.height.equalTo(55)
        }
        
        repwdTextField.placeholder = "请再次输入密码"
        repwdTextField.borderStyle = .roundedRect
        repwdTextField.isSecureTextEntry = true
        self.view.addSubview(repwdTextField)
        repwdTextField.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pwdTextField.snp.bottom).offset(20)
            $0.left.equalTo(pwdTextField.snp.left)
            $0.height.equalTo(55)
        })
        
        nextButton.setTitle("下一步", for: .normal)
        nextButton.backgroundColor = UIColor(valueStr: "FBEA77")
        nextButton.setTitleColor(UIColor.black, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        nextButton.layer.borderWidth = 0.5
        nextButton.layer.cornerRadius = 8
        nextButton.layer.shadowOffset = CGSize(width: 1,height: 1)
        nextButton.layer.shadowOpacity = 0.8
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(repwdTextField.snp.bottom).offset(30)
            $0.left.equalTo(100)
            $0.height.equalTo(55)
        })
    }
    
    @objc func cancel() {
          self.navigationController?.popViewController(animated: true)
      }
    
    @objc func done(){
        guard pwdTextField.text!.range(of: #"^(?!\d+$)(?![a-z]+$)(?![A-Z]+$)(?!([^(0-9a-zA-Z)])+$)[0-9a-zA-Z\-/:;()$&@".,?!'\[\]{}#%^*+=_\\|~<>]{8,14}$"#, options: .regularExpression) != nil else {
            ProgressHUD.showFailed("密码不合法")
            return }
        guard pwdTextField.text == repwdTextField.text else {
            ProgressHUD.showFailed("两次密码不一致")
            return}
        user.register(pho: user.pho, pwd: pwdTextField.text!, key: key, code: code).subscribe(onNext: { string in
            if string == "success" {
                user.save()
                self.navigationController?.pushViewController(IntroAMViewController(), animated: true)
            } else {
                 ProgressHUD.showFailed(string)
            }
            
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disponseBag)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pwdTextField.resignFirstResponder()
        repwdTextField.resignFirstResponder()
    }



}
