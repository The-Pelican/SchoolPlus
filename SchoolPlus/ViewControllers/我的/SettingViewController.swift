//
//  SettingViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/27.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import YPImagePicker
import ProgressHUD
import Kingfisher

class SettingViewController: UIViewController {
    let logoutButton = UIButton()
    var avartarLabel:UILabel!
    var imageView:UIImageView!
    var checkLabel:UILabel!
    var infoLabel:UILabel!
    var avatar = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        /*if let url = URL(string: user.avatar) {
            imageView.kf.setImage(with: url)
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        user.getMyMessage().subscribe(onNext:{ string in
            self.imageView.kf.setImage(with: URL(string:user.avatar))
        })
    }
    
    func initSubView() {
        title = "设置"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        avartarLabel = UILabel()
        avartarLabel.text = "我的头像"
        self.view.addSubview(avartarLabel)
        avartarLabel.snp.makeConstraints({
            $0.top.equalTo(navigationBarHeight + safeAreaTopHeight+44)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
            $0.left.equalTo(28)
        
        })
        
        imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.image = UIImage(named: "怪物")
        if let url = URL(string: user.avatar) {
            print(user.avatar)
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        imageView.image = image
                    }
                } catch let error as NSError {
                    ProgressHUD.showFailed("头像加载失败")
                }
            }
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeAvartar))
        imageView.addGestureRecognizer(tap)
        imageView.snp.makeConstraints({
            $0.top.equalTo(navigationBarHeight + safeAreaTopHeight+44)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
            $0.right.equalToSuperview().offset(-28)
        })
        
        checkLabel = UILabel()
        checkLabel.text = "我的认证信息"
        self.view.addSubview(checkLabel)
        checkLabel.snp.makeConstraints({
            $0.top.equalTo(avartarLabel.snp.bottom).offset(50)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
            $0.left.equalTo(28)
        })
        
        infoLabel = UILabel()
        switch user.hasChecked {
        case true:
            infoLabel.text = user.name
        case false:
            infoLabel.text = "认证失败"
        case nil:
            infoLabel.text = "未认证"
        default:
            infoLabel.text = "未知"
        }
        infoLabel.textAlignment = .center
        self.view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints({
            $0.top.equalTo(checkLabel.snp.top)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
            $0.right.equalToSuperview()
        })
        
        
        
        self.view.addSubview(logoutButton)
        logoutButton.setTitle("退出账号", for: .normal)
        logoutButton.backgroundColor = UIColor.systemBlue
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-80)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            
        })
        
        
        
    }
    
    @objc func logout() {
        UIAlertController.showConfirm(message: "确定退出登陆？", in: self, confirm: { action in
            user.logout()
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            Navigator.window().rootViewController = navigationController
        })
    }
    
    @objc func changeAvartar() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let check = UIAlertAction(title: "查看头像", style: .default) {
            [weak self] _ in
            guard let image = self?.imageView.image else {return}
            var images = [UIImage]()
            images.append(image)
            let vc = ImageDetailViewController(images: images)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let edit = UIAlertAction(title: "更改头像", style: .default) {
            [weak self]_ in
            let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self?.avatar = photo.image
                }
                picker.dismiss(animated: true, completion: nil)
                user.changeAvatar(image: self!.avatar).subscribe(onNext:{ string in
                    ProgressHUD.showSucceed()
                },onError: { error in
                    ProgressHUD.showFailed()
                })
            }
            self?.present(picker, animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(edit)
        alert.addAction(check)
        present(alert, animated: true, completion: nil)
    }
    


}
