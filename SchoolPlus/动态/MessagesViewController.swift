//
//  MessagesViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/13.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import RxSwift
import ProgressHUD
import MJRefresh

enum MessageType:Int {
    case all = 1
    case subscribed = 2
    case my = 3
    case group = 4
}

class MessagesViewController: UIViewController {
    var tableView =  UITableView()
    var addButton = UIButton()
    var navigationBar:UINavigationBar?
    var loadView: UIView?
    let model = InformationViewModel()
    var isAll = true
    var messages:[Infomation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let infoType:MessageType
    
    let disposeBag = DisposeBag()
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshBackNormalFooter()
    
    init(type:String) {

        switch type {
        case "全部":
            infoType = .all
        case "已关注":
            infoType = .subscribed
        case "我的":
            infoType = .my
        case "组织":
            infoType = .group
        default:
            infoType = .my
        }
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.message = []
        model.pageNum = 0
        if infoType == .all {
            model.getData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else if infoType == .subscribed {
            model.getSubscribeData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else if infoType == .my {
            model.getMyData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            },onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            })
        }
    }
    
    func getData() {
        
    }
    
    func initTableView() {
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.lightGray
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        })
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: MessageTableViewCell.identifier)
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_header = header
        header.setTitle("下拉可以刷新", for: .idle)
        header.setTitle("正在刷新中", for: .refreshing)
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        self.tableView.mj_footer = footer
    }
    
    @objc func headerRefresh(){
        model.message = []
        model.pageNum = 0
        if infoType == .all {
            model.getData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else if infoType == .subscribed{
            model.getSubscribeData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            
        } else {
            model.getMyData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
        tableView.reloadData()
        self.tableView.mj_header!.endRefreshing()
    }
    

    
    @objc func footerLoad() {
        if infoType == .all {
            model.getData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else if infoType == .subscribed{
            model.getSubscribeData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            model.getMyData().subscribe(onNext:{ string in
                self.messages = self.model.message
                self.model.pageNum = self.model.pageNum + 1
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
        tableView.reloadData()
        self.tableView.mj_footer!.endRefreshing()
    }
    
    
    @objc func create() {
        if user.hasChecked == true {
            let vc = UpdateMessageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            ProgressHUD.showFailed("功能尚未解锁")
        }
      }
    
    func initButton() {
        addButton.setTitle("➕", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.layer.borderWidth = 0.5
        addButton.layer.cornerRadius = 25
        addButton.layer.shadowOffset = CGSize(width: 3,height: 3)
        addButton.layer.shadowOpacity = 0.8
        addButton.layer.shadowColor = UIColor.init(valueStr: "FBEA77").cgColor
        addButton.backgroundColor = UIColor(valueStr: "FBEA77")
        addButton.addTarget(self, action: #selector(create), for: .touchUpInside)
        self.view.addSubview(addButton)
        addButton.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(tableView.snp.bottom).offset(-100)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        })
    }
    
    
    
}

extension MessagesViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
        
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.reloadData( date: messages[indexPath.row].publishTime ?? "00000000", content: messages[indexPath.row].text ?? "", images: messages[indexPath.row].media ?? [String](), like: messages[indexPath.row].likesNum!, comment: messages[indexPath.row].commentsNum!,hasLike: messages[indexPath.row].hasLiked ?? false)
        cell.info = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击")
        let vc = CommentViewController()
        vc.newsId = self.messages[indexPath.row].newsId ?? -1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("正在滚动")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("停止滚动")
    }
    

}
