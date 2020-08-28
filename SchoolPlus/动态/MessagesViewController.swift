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

class MessagesViewController: UIViewController {
    var tableView =  UITableView()
    var addButton = UIButton()
    var navigationBar:UINavigationBar?
    var loadView: UIView?
    let model = InformationViewModel()
    var messages:[Infomation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    let footer = MJRefreshBackNormalFooter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.message = []
        model.pageNum = 0
        model.getData().subscribe(onNext:{ string in
            self.messages = self.model.message
            self.model.pageNum = self.model.pageNum + 1
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
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
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        self.tableView.mj_footer = footer
    }
    

    
    @objc func footerLoad() {
        model.getData().subscribe(onNext:{ string in
            self.messages = self.model.message
            self.model.pageNum = self.model.pageNum + 1
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        tableView.reloadData()
        self.tableView.mj_footer!.endRefreshing()
    }
    
    
    @objc func create() {
          let vc = UpdateMessageViewController()
          self.navigationController?.pushViewController(vc, animated: true)
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
        
        cell.info = messages[indexPath.row]
        cell.reloadData(sender: messages[indexPath.row].sender, date: messages[indexPath.row].date, content: messages[indexPath.row].content, images: messages[indexPath.row].audioPath, like: messages[indexPath.row].like, comment: messages[indexPath.row].comment,avartar:messages[indexPath.row].avartar, hasLike: messages[indexPath.row].hasLiked,hasSubscribed: messages[indexPath.row].hasSubscribe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击")
        let vc = CommentViewController()
        vc.info = self.messages[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("正在滚动")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //print("停止滚动")
    }
    

}
