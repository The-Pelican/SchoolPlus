//
//  OnthersViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/31.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import RxSwift
import ProgressHUD
import Kingfisher


class OnthersViewController: UIViewController {
    let blockViewHeight = 250
    let disposeBag = DisposeBag()
    let model = MyViewModel()
    var scrollView = UIScrollView()
    var logoImageView = UIImageView()
    var nameLabel = UILabel()
    var logo:[UIImageView] = []
    var introLabel:[UILabel] = []
    var totalButton:[UIButton] = []
    var groupTableView = UITableView()
    var newsTableView = UITableView()
    var whiteView:[UIView] = []
    var backView:[UIView] = []
    var setButton = UIButton()
    var userId = -1
    var user: UserInfo?
    var groups:[Organization] = [] {
        didSet {
            print("他人组织")
            groupTableView.reloadData()
        }
    }
    var news:[Infomation] = [] {
        didSet {
            newsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()

    }
    
    
    func getData() {
        ProgressHUD.show("正在加载中")
        model.pageNum = 0
        model.userList = []
        model.organizationList = []
        model.newsList =  []
        model.getUserGroups(id: user?.userId ?? -1).subscribe(onNext:{ [weak self]list in
            self?.groups = list
        },onError: { [weak self]error in
            ProgressHUD.showFailed()
            self?.groups = []
        })
        
        model.getUserNews(id: user?.userId ?? -1).subscribe(onNext:{ [weak self]list in
            self?.news = list
            ProgressHUD.dismiss()
        },onError: { [weak self]error in
            ProgressHUD.showFailed()
            self?.news = []
        })
    }
    
    
    
    func initSubView() {
        
        self.view.backgroundColor = UIColor.white
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 950)
        self.view.addSubview(scrollView)
        logoImageView.image = UIImage(named: "雅典娜")
        logoImageView.layer.cornerRadius = 50
        logoImageView.clipsToBounds = true
        self.scrollView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(100)
            $0.top.equalTo(80)
        })
        
        if let user = user {
            nameLabel.text = user.studentName ?? "无名"
            if let url = URL(string: user.avatar ?? "") {
            print(user.avatar)
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        logoImageView.image = image
                    }
                } catch let error as NSError {
                    ProgressHUD.showFailed("头像加载失败")
                }
            }
        }
        
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
        
        nameLabel.textAlignment = .center
        self.scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(35)
        })
        
        
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
        introLabel[0].text = "ta的组织"
        whiteView[0].addButtonLine()
        
        groupTableView = UITableView()
        backView[0].addSubview(groupTableView)
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.separatorStyle = .none
        //groupTableView.backgroundColor = UIColor.purple
        groupTableView.isScrollEnabled = false
        groupTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: ListTableViewCell.identifier)
        groupTableView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.left.equalTo(whiteView[0].snp.left)
            $0.top.equalTo(whiteView[0].snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-15)
        })
        
        backView[0].addSubview(totalButton[0])
        totalButton[0].setTitle("查看全部", for: .normal)
        totalButton[0].addTarget(self, action: #selector(groupList), for: .touchUpInside)
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
        introLabel[1].text = "ta的动态"
        whiteView[1].addButtonLine()
        
        
        newsTableView = UITableView()
        backView[1].addSubview(newsTableView)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.separatorStyle = .none
        newsTableView.isScrollEnabled = false
        newsTableView.register(UINib(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: TimeLineTableViewCell.identifier)
        newsTableView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.left.equalTo(whiteView[1].snp.left)
            $0.top.equalTo(whiteView[1].snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-15)
        })
        
        backView[1].addSubview(totalButton[1])
        totalButton[1].setTitle("查看全部", for: .normal)
        totalButton[1].addTarget(self, action: #selector(newsList), for: .touchUpInside)
        totalButton[1].setTitleColor(UIColor.systemBlue, for: .normal)
        totalButton[1].snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-3)
            $0.width.equalTo(100)
            $0.height.equalTo(15)
        })
        
        for i in logo {
            i.backgroundColor = UIColor.white
            i.image = UIImage(named: "shetuan-1")
        }
        
    }
    
    func setNavigationBar() {
        
    }
    
    @objc func groupList() {
        let vc = InfoDetailViewController()
        vc.groups = self.groups
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func newsList() {
           let vc = MyMessagesViewController()
           self.navigationController?.pushViewController(vc, animated: true)
       }
    

}

extension OnthersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == groupTableView {
            if groups.count > 3 {
                return 3
            }
            return groups.count
        }
        
        if news.count > 3 {
            return 3
        }
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineTableViewCell.identifier, for: indexPath) as! TimeLineTableViewCell
            cell.contentLabel?.text = news[indexPath.row].text
            cell.dateLabel.text = news[indexPath.row].publishTime
            if let media = news[indexPath.row].media {
                if !media.isEmpty {
                    if let url = URL(string: media.first ?? "") {
                        cell.picView?.kf.setImage(with:url)
                    }
                }
            }
            return cell
        } else {
             var cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
            cell.nameLabel?.text = groups[indexPath.row].organizationName
                           if let strUrl = groups[indexPath.row].logo {
                                  if let url = URL(string: strUrl) {
                                   cell.picView.kf.setImage(with:url)
                                  }
                           }
            cell.identityLabel.text = ""
            return cell
            
        }
        
       /* let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        if tableView == groupTableView {
            cell?.textLabel?.text = groups[indexPath.row].organizationName
            cell?.imageView?.image = UIImage(named: "阿波罗")
        } else {
            cell?.textLabel?.text = news[indexPath.row].text
        }
        return cell!*/
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if tableView == newsTableView {
               let vc = CommentViewController()
               vc.newsId = news[indexPath.row].newsId ?? -1
               self.navigationController?.pushViewController(vc, animated: true)
           } else if tableView == groupTableView {
               let vc = GroupDetailViewController()
               vc.organizationId = groups[indexPath.row].organizationId ?? -1
               self.navigationController?.pushViewController(vc, animated: true)
           }
       }
    
    
}
