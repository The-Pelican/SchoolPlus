//
//  AuthenticationViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/11.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import YPImagePicker
import ProgressHUD
import RxSwift
import Alamofire
import SwiftyJSON

class AuthenticationViewController: UIViewController {
    var numTextField = UITextField()
    var nameTextField = UITextField()
    var nameLabel = UILabel()
    var numLabel = UILabel()
    var picLabel = UILabel()
    var detailLabel = UILabel()
    var label = UILabel()
    var imageView = UIImageView()
    var button = UIButton()
    var image:UIImage? {
        didSet {
            guard let image = image else {return}
            imageView.image = image
        }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initSubView() {
         title = "个人认证"
         self.view.backgroundColor = UIColor.white
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        nameLabel.text = "中文姓名"
        nameLabel.font = UIFont.boldSystemFont(ofSize:20)
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({
            $0.top.equalTo(100)
            $0.left.equalTo(28)
            $0.height.equalTo(55)
            $0.width.equalTo(100)
        })
        
        
        nameTextField.placeholder = "请输入真实姓名"
        nameTextField.borderStyle = .roundedRect
        self.view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.top)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(55)
            $0.left.equalTo(nameLabel.snp.right).offset(10)
        })
        
        numLabel.text = "学号"
        numLabel.font = UIFont.boldSystemFont(ofSize:20)
        self.view.addSubview(numLabel)
        numLabel.snp.makeConstraints({
            $0.top.equalTo(nameTextField.snp.bottom).offset(20)
            $0.left.equalTo(28)
            $0.height.equalTo(55)
            $0.width.equalTo(100)
        })
        
        numTextField.placeholder = "请输入学号"
        numTextField.borderStyle = .roundedRect
        self.view.addSubview(numTextField)
        numTextField.snp.makeConstraints{
            $0.left.equalTo(numLabel.snp.right).offset(10)
            $0.top.equalTo(nameTextField.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(55)
        }
        
        
        picLabel.text = "学生卡照片"
        picLabel.font = UIFont.boldSystemFont(ofSize:20)
        self.view.addSubview(picLabel)
        picLabel.snp.makeConstraints({
            $0.top.equalTo(numTextField.snp.bottom).offset(20)
            $0.left.equalTo(28)
            $0.height.equalTo(55)
            $0.width.equalTo(150)
        })
        
        
        
        label.text = "请上传您的学生卡包含个人信息面的照片，照片仅用于用户认证"
        label.font = UIFont.systemFont(ofSize:13)
        self.view.addSubview(label)
        label.snp.makeConstraints({
            $0.top.equalTo(picLabel.snp.bottom).offset(20)
            $0.left.equalTo(numLabel.snp.left)
        })
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 2
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPicture))
        imageView.addGestureRecognizer(tap)
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(10)
            $0.left.equalTo(label.snp.left)
            $0.height.equalTo(150)
        })
        
        button.setTitle("提交认证", for: .normal)
        button.layer.shadowOffset = CGSize(width: 1,height: 1)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.black.cgColor
        button.backgroundColor = UIColor(valueStr: "FBEA77")
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        self.view.addSubview(button)
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.left.equalTo(label.snp.left).offset(50)
            $0.height.equalTo(45)
        })
        
        detailLabel.text = "审核时间为1-2个工作日，审核通过后即可解锁所有功能"
        detailLabel.font = UIFont.systemFont(ofSize:13)
        self.view.addSubview(detailLabel)
        detailLabel.snp.makeConstraints({
            $0.top.equalTo(button.snp.bottom).offset(10)
            $0.left.equalTo(numLabel.snp.left)
            $0.height.equalTo(30)
        })
    }
    
    @objc func addPicture() {
        print("点击imageview")
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc func done() {
        guard !(nameTextField.text!.isEmpty) && !(numTextField.text!.isEmpty) && image != nil else {
            ProgressHUD.showFailed("请完善")
            return
        }
        
        /*for char in nameTextField.text! {
            /*if !("\u{4E00}" <= char && char <= "\u{9FA5}") {
                ProgressHUD.showFailed("请输入正确的姓名")
            }*/
        }*/
        user.uploadAM(name: nameTextField.text!, num: numTextField.text!, card: image!).subscribe(onNext: { [weak self]string in
            if string == "success" {
                user.save()
                ProgressHUD.showSucceed("提交成功")
                self?.navigationController?.pushViewController(EndAMViewController(), animated: true)
            } else {
                ProgressHUD.showFailed(string)
            }
           
        }, onError: { error in
            ProgressHUD.showFailed("提交失败")
        }).disposed(by:disposeBag)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }




}
