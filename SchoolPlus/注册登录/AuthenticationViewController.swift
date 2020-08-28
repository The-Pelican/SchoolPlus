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
    
    func initSubView() {
         title = "实名认证"
         self.view.backgroundColor = UIColor.white
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
         self.navigationController?.navigationBar.shadowImage = UIImage()
        numTextField.placeholder = "请输入学号"
        numTextField.borderStyle = .roundedRect
        self.view.addSubview(numTextField)
        numTextField.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(150)
            $0.left.equalTo(28)
            $0.height.equalTo(55)
        }
        
        nameTextField.placeholder = "请输入真实姓名"
        nameTextField.borderStyle = .roundedRect
        self.view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(numTextField.snp.bottom).offset(20)
            $0.left.equalTo(numTextField.snp.left)
            $0.height.equalTo(55)
        })
        
        label.text = "请上传您的学生卡照片（正面）"
        self.view.addSubview(label)
        label.snp.makeConstraints({
            $0.top.equalTo(nameTextField.snp.bottom).offset(40)
            $0.left.equalTo(nameTextField.snp.left)
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
            $0.top.equalTo(label.snp.bottom).offset(5)
            $0.left.equalTo(label.snp.left)
            $0.height.equalTo(150)
        })
        
        button.setTitle("完成", for: .normal)
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
            $0.left.equalTo(label.snp.left)
            $0.height.equalTo(55)
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
        
        guard image != nil else {return}
        print("调用")
        user.uploadAM(name: nameTextField.text!, num: numTextField.text!, card: image!).subscribe(onNext: { string in
            user.save()
            ProgressHUD.showSucceed("流程完成！")
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
        }).disposed(by:disposeBag)
        /*guard image != nil else {return}
        print("调用")
        let studentName = nameTextField.text!.data(using: String.Encoding.utf8)
        let studentNo = numTextField.text!.data(using: String.Encoding.utf8)
        let cardData = image?.jpegData(compressionQuality: 1)
        let headers: HTTPHeaders
        headers = ["accessToken":user.accessToken]
        print(cardData!)
        AF.upload(multipartFormData: { (multiPart) in
             multiPart.append(studentNo!, withName: "studentNo")
             multiPart.append(studentName!, withName: "studentName")
             multiPart.append(cardData!, withName: "card", fileName:  "card.jpeg", mimeType: "image/jpeg")
        }, to: "http://www.chenzhimeng.top/fu-community/user/identity", usingThreshold:UInt64.init(), method: .put, headers:headers).response { response in
            print(response)
        }*/
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }




}
