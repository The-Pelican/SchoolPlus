//
//  CreateGroupViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/22.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import YPImagePicker

class CreateGroupViewController: UIViewController {
    var logoLabel = UILabel()
    var logo = UIImageView()
    var groupLabel = UILabel()
    var groupTextField = UITextField()
    var sloganLabel = UILabel()
    var sloganTextField = UITextField()
    var contentLabel = UILabel()
    var contentTextView = UITextView()
    var button = UIButton()
    var image:UIImage? {
        didSet {
            guard let image = image else {return}
            logo.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    
    func initSubView() {
        title = "创建组织"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        logoLabel.text = "Logo:"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints({
            $0.top.equalTo(navigationBarHeight+80)
            $0.left.equalTo(28)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        })
        
        logo.layer.borderWidth = 1
        logo.layer.borderColor = UIColor.black.cgColor
        logo.layer.cornerRadius = 35
        logo.clipsToBounds = true
        //imageView.contentMode = .scaleAspectFill
        logo.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPicture))
        logo.addGestureRecognizer(tap)
        self.view.addSubview(logo)
        logo.snp.makeConstraints({
            $0.top.equalTo(logoLabel.snp.top)
            $0.left.equalTo(logoLabel.snp.right)
            $0.height.width.equalTo(70)
        })
        
        groupLabel.text = "组织名称："
        groupLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(groupLabel)
        groupLabel.snp.makeConstraints({
            $0.top.equalTo(logoLabel.snp.bottom).offset(50)
            $0.left.equalTo(logoLabel.snp.left)
            $0.height.equalTo(30)
            $0.width.equalTo(110)
        })
        
        groupTextField.borderStyle = .none
        groupTextField.addButtonLine()
        self.view.addSubview(groupTextField)
        groupTextField.snp.makeConstraints({
            $0.top.equalTo(groupLabel.snp.top)
            $0.left.equalTo(groupLabel.snp.right)
            $0.height.equalTo(30)
            $0.width.equalTo(200)
        })
        
        sloganLabel.text = "Slogan:"
        sloganLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(sloganLabel)
        sloganLabel.snp.makeConstraints({
            $0.top.equalTo(groupLabel.snp.bottom).offset(30)
            $0.left.equalTo(logoLabel.snp.left)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        })
        
        sloganTextField.borderStyle = .none
        sloganTextField.addButtonLine()
        self.view.addSubview(sloganTextField)
        sloganTextField.snp.makeConstraints({
            $0.top.equalTo(sloganLabel.snp.top)
            $0.left.equalTo(sloganLabel.snp.right)
            $0.height.equalTo(30)
            $0.width.equalTo(200)
        })
        
        contentLabel.text = "简介:"
        contentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints({
            $0.top.equalTo(sloganLabel.snp.bottom).offset(30)
            $0.left.equalTo(logoLabel.snp.left)
            $0.height.equalTo(30)
            $0.width.equalTo(80)
        })
        
        self.view.addSubview(contentTextView)
        contentTextView.text = "简介"
        contentTextView.snp.makeConstraints({
            $0.top.equalTo(contentLabel.snp.top).offset(30)
            $0.left.equalTo(sloganLabel.snp.left)
            $0.height.equalTo(200)
            $0.width.equalTo(200)
        })
        
        button.setTitle("创建一个组织", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 3,height: 3)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.init(valueStr: "FBEA77").cgColor
        button.backgroundColor = UIColor(valueStr: "FBEA77")
        //button.addTarget(self, action: #selector(create), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.view.frame.height).offset(-(tabBarHeight+30))
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        })
    }
    
    @objc func addPicture() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let edit = UIAlertAction(title: "选择图片", style: .default) {
            [weak self] _ in
            let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self?.image = photo.image
                }
                picker.dismiss(animated: true, completion: nil)
            }
            self?.present(picker, animated: true, completion: nil)
        }
        let detail = UIAlertAction(title: "查看图片", style: .default, handler: {
            [weak self] _ in
            guard let image = self?.image else {return}
            var images:[UIImage] = []
            images.append(image)
            let vc = ImageDetailViewController(images: images)
            vc.images.append(image)
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        alert.addAction(cancel)
        alert.addAction(edit)
        alert.addAction(detail)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        groupTextField.resignFirstResponder()
        sloganTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
    }

    
}
