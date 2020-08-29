//
//  MyViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    let blockViewHeight = 250
    
    var scrollView = UIScrollView()
    var logoImageView = UIImageView()
    var nameLabel = UILabel()
    var logo:[UIImageView] = []
    var introLabel:[UILabel] = []
    var totalButton:[UIButton] = []
    var groupTableView = UITableView()
    var usersTableView = UITableView()
    var newsTableView = UITableView()
    var whiteView:[UIView] = []
    var backView:[UIView] = []
    var setButton = UIButton()
    let groups = ["DBL","西二","花样跳绳"]
    let users = ["张三","李四","王五"]
    let subscribeGroup = ["?","?","?"]
    let news = ["这是一条信息","这是另一条"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    func initSubView() {
        self.view.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 950)
        self.view.addSubview(scrollView)
        
        
        
        
        logoImageView.image = UIImage(named: "雅典娜")
        self.scrollView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(100)
            $0.top.equalTo(80)
        })
        
        
        
        nameLabel.text = "特朗普"
        nameLabel.textAlignment = .center
        self.scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(35)
        })
        
        for _ in 0...2 {
            let background = UIView()
            backView.append(background)
            
            let bar = UIView()
            whiteView.append(bar)
            
            let logo = UIImageView()
            self.logo.append(logo)
            
            let introLabel = UILabel()
            self.introLabel.append(introLabel)
            
            let button = UIButton()
            self.totalButton.append(button)
        }
        
        self.scrollView.addSubview(backView[0])
        backView[0].layer.borderWidth = 1
        backView[0].layer.cornerRadius = 5
        backView[0].backgroundColor = UIColor.white
        backView[0].snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(200)
        })
        
        backView[0].addSubview(whiteView[0])
        whiteView[0].backgroundColor = UIColor.white
        whiteView[0].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        })
        
        
        whiteView[0].addSubview(logo[0])
        logo[0].backgroundColor = UIColor.green
        logo[0].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        })
        
        whiteView[0].addSubview(introLabel[0])
        introLabel[0].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalTo(logo[0].snp.right).offset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(100)
        })
        introLabel[0].text = "我的组织"
        whiteView[0].addButtonLine()
        
        backView[0].addSubview(groupTableView)
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.separatorStyle = .none
        groupTableView.isScrollEnabled = false
        groupTableView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.left.equalTo(whiteView[0].snp.left)
            $0.top.equalTo(whiteView[0].snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-15)
        })
        
        backView[0].addSubview(totalButton[0])
        totalButton[0].setTitle("查看全部", for: .normal)
        totalButton[0].setTitleColor(UIColor.systemBlue, for: .normal)
        totalButton[0].snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-3)
            $0.width.equalTo(100)
            $0.height.equalTo(15)
        })
        
        self.scrollView.addSubview(backView[1])
        backView[1].layer.borderWidth = 1
        backView[1].layer.cornerRadius = 5
        backView[1].backgroundColor = UIColor.white
        backView[1].snp.makeConstraints({
            $0.top.equalTo(backView[0].snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(200)
        })
        
        backView[1].addSubview(whiteView[1])
        whiteView[1].backgroundColor = UIColor.white
        whiteView[1].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        })
        
        
        whiteView[1].addSubview(logo[1])
        logo[1].backgroundColor = UIColor.green
        logo[1].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        })
        
        whiteView[1].addSubview(introLabel[1])
        introLabel[1].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalTo(logo[1].snp.right).offset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(100)
        })
        introLabel[1].text = "我关注的人"
        whiteView[1].addButtonLine()
        
        backView[1].addSubview(usersTableView)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.separatorStyle = .none
        usersTableView.isScrollEnabled = false
        usersTableView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.left.equalTo(whiteView[1].snp.left)
            $0.top.equalTo(whiteView[1].snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-15)
        })
        
        backView[1].addSubview(totalButton[1])
        totalButton[1].setTitle("查看全部", for: .normal)
        totalButton[1].setTitleColor(UIColor.systemBlue, for: .normal)
        totalButton[1].snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-3)
            $0.width.equalTo(100)
            $0.height.equalTo(15)
        })
        
        self.scrollView.addSubview(backView[2])
        backView[2].layer.borderWidth = 1
        backView[2].layer.cornerRadius = 5
        backView[2].backgroundColor = UIColor.white
        backView[2].snp.makeConstraints({
            $0.top.equalTo(backView[1].snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.height.equalTo(200)
        })
        
        backView[2].addSubview(whiteView[2])
        whiteView[2].backgroundColor = UIColor.white
        whiteView[2].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        })
        
        
        
        whiteView[2].addSubview(logo[2])
        logo[2].backgroundColor = UIColor.green
        logo[2].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        })
        
        whiteView[2].addSubview(introLabel[2])
        introLabel[2].snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalTo(logo[2].snp.right).offset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(100)
        })
        introLabel[2].text = "我的组织"
        whiteView[2].addButtonLine()
        
        backView[2].addSubview(newsTableView)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.separatorStyle = .none
        newsTableView.isScrollEnabled = false
        newsTableView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.left.equalTo(whiteView[2].snp.left)
            $0.top.equalTo(whiteView[2].snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-15)
        })
        
        backView[2].addSubview(totalButton[2])
        totalButton[2].setTitle("查看全部", for: .normal)
        totalButton[2].setTitleColor(UIColor.systemBlue, for: .normal)
        totalButton[2].snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-3)
            $0.width.equalTo(100)
            $0.height.equalTo(15)
        })
        
        setButton.setTitle("设置", for: .normal)
        setButton.setTitleColor(UIColor.systemBlue, for: .normal)
        self.scrollView.addSubview(setButton)
        setButton.addTarget(self, action: #selector(setting), for: .touchUpInside)
        setButton.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.right.equalTo(backView[0].snp.right)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        })
        
    }
    
    
    @objc func setting() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == groupTableView {
            if groups.count > 3 {
                return 3
            }
            return groups.count
        } else if tableView == usersTableView {
            if users.count > 3 {
                return 3
            }
            return users.count
        }
        
        if news.count > 3 {
            return 3
        }
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        if tableView == groupTableView {
            cell?.textLabel?.text = groups[indexPath.row]
        } else if tableView == usersTableView {
            cell?.textLabel?.text = users[indexPath.row]
        } else {
            cell?.textLabel?.text = news[indexPath.row]
        }
        
        cell?.imageView?.image  = UIImage(named: "阿波罗")
        return cell!
    }
    
    
}
