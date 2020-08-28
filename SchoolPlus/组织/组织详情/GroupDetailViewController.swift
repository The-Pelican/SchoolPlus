//
//  GroupDetailViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/23.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    var group = Organization()
    var logo = UIImageView()
    var detail = UIView()
    let nameLabel = UILabel()
    let sloganLabel = UILabel()
    let nameContentLabel = UILabel()
    let sloganContentLabel = UILabel()
    let descriptionLabel = UILabel()
    let descriptionContentLabel = UILabel()
    let founderLabel = UILabel()
    let founderContentLabel = UILabel()
    let counterLabel = UILabel()
    let counterContentLabel = UILabel()
    var messageLabel = UILabel()
    var messageView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    func initSubView() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let addButton = UIBarButtonItem(title: "添加", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = addButton
        
        logo.backgroundColor = UIColor.black
        logo.layer.cornerRadius = 30
        logo.clipsToBounds = true
        self.view.addSubview(logo)
        logo.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(100)
            $0.height.equalTo(60)
            $0.width.equalTo(60)
        })
        
        detail.layer.borderWidth = 1
        detail.layer.borderColor = UIColor.black.cgColor
        detail.layer.cornerRadius = 5
        self.view.addSubview(detail)
        detail.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(15)
            $0.left.equalTo(28)
            $0.height.equalTo(200)
        })
        
        nameLabel.text = "名称：  \(group.organizationName ?? "无名")"
        self.detail.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(5)
            $0.width.equalTo(300)
        })
        
        sloganLabel.text = "Slogan：\(group.slogan)"
        self.detail.addSubview(sloganLabel)
        sloganLabel.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.equalTo(5)
            $0.width.equalTo(300)
        })
        
        descriptionLabel.text = "简介:"
        self.detail.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints({
            $0.top.equalTo(sloganLabel.snp.bottom).offset(20)
            $0.left.equalTo(5)
        })
        
        descriptionContentLabel.text = "\(group.intro)"
        descriptionContentLabel.numberOfLines = 0
        self.detail.addSubview(descriptionContentLabel)
        descriptionContentLabel.snp.makeConstraints({
            $0.top.equalTo(sloganLabel.snp.bottom).offset(20)
            $0.left.equalTo(descriptionLabel.snp.right).offset(5)
            $0.width.equalTo(300)
        })
        
        
        founderLabel.text = "创始人：\(group.auditor ?? "")"
        self.detail.addSubview(founderLabel)
        founderLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-5)
            $0.left.equalTo(5)
        })
        
        counterLabel.text = "成员数量:"
        self.detail.addSubview(counterLabel)
        counterLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-5)
            $0.left.equalTo(detail.snp.centerX).offset(10)
        })
        
        messageLabel.text = "动态"
        messageLabel.textAlignment = .center
        self.view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(detail.snp.bottom).offset(20)
        })
        
        messageView.backgroundColor = UIColor.blue
        messageView.delegate = self
        messageView.dataSource = self
        messageView.separatorStyle = .none
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: nil)
        messageView.register(nib, forCellReuseIdentifier: TimeLineTableViewCell.identifier)
        self.view.addSubview(messageView)
        messageView.snp.makeConstraints({
            $0.top.equalTo(messageLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(500)
            $0.width.equalTo(400)
        })
    }
    
}

extension GroupDetailViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineTableViewCell.identifier,for: indexPath) as! TimeLineTableViewCell
        cell.dateLabel.text = "048月"
        cell.picView.image = UIImage(named: "宙斯")
        cell.contentLabel.text = "西二在线，为你在线\n \n \n"
        return cell
    }
    
    
}
