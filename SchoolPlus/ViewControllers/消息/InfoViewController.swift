//
//  InfoViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import RxSwift
import ProgressHUD
import MJRefresh

class InfoViewController: UIViewController {
    var typeIndex = 0
    var tableView = UITableView()
    var notices:[Notice] = [] {
        didSet {
            for i in notices {
                print("获取成功\(i.type)")
                if (i.type! != 1 && i.type! != 4) {
                    print("阅读")
                    if i.hasRead == false {
                        model.read(id: i.messageId ?? -1)
                    }
                }
            }
            tableView.reloadData()
        }
    }
    let model = InfoViewModel()
    let disposeBag = DisposeBag()
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshBackNormalFooter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        initTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.typeNotices = []
        model.pageNum = 0
        model.getNotice(type: typeIndex).subscribe(onNext:{ list in
            self.notices = list
            },onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        model.unread().subscribe(onNext:{ string in
            let window = Navigator.window()
            if let navvc = window.rootViewController as? UINavigationController {
                if let vc =  navvc.viewControllers[0] as? MainTabViewController {
                    
                    vc.infoItem.badgeValue = string
                    if  string == "0" {
                        vc.infoItem.badgeValue = nil
                    }
                }
            }
        },onError: { error in
            ProgressHUD.showFailed(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func initTableView() {
        tableView.backgroundColor = UIColor.lightGray
        tableView.frame = self.view.frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_header = header
        header.setTitle("下拉可以刷新", for: .idle)
        header.setTitle("正在刷新中", for: .refreshing)
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        self.tableView.mj_footer = footer
        
        self.view.addSubview(tableView)
    }
    
    @objc func headerRefresh(){
        self.model.pageNum = 0
        self.model.notices = [1:[Notice](),2:[Notice](),3:[Notice](),4:[Notice](),5:[Notice](),6:[Notice]()]
        self.model.typeNotices = []
        model.moreNotice(type: typeIndex).subscribe(onNext:{ notices in
            self.notices = notices
            self.model.pageNum += 1
        },onError: { error in
            ProgressHUD.showError()
            } ).disposed(by: disposeBag)
        tableView.reloadData()
        self.tableView.mj_header!.endRefreshing()
    }
    
    
    @objc func footerLoad() {
        model.moreNotice(type: typeIndex).subscribe(onNext:{ notices in
            self.notices = notices
            self.model.pageNum += 1
        },onError: { error in
            ProgressHUD.showError()
            } ).disposed(by: disposeBag)
        tableView.reloadData()
        self.tableView.mj_footer!.endRefreshing()
    }
    

}

extension InfoViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        let time = (notices[indexPath.row].time)!
        let date = timeIntervalToString(timeInterval: Double(time))
        cell.reloadData(time: date, content: notices[indexPath.row].content ?? "暂无内容",hasRead: notices[indexPath.row].hasRead ?? false)
        if notices[indexPath.row].type! == 1 {
            cell.contentLabel.text = "您的动态收到新回复"
        } else if notices[indexPath.row].type! == 4 {
            cell.contentLabel.text = "您的关注人发布新动态"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(notices[indexPath.row].messageId!)
        if notices[indexPath.row].type == 1 || notices[indexPath.row].type == 4 {
            if let i = Int(self.notices[indexPath.row].content ?? "-1") {
                let vc = CommentViewController()
                model.read(id: notices[indexPath.row].messageId!)
                vc.newsId = i
                self.navigationController?.pushViewController(vc, animated: true)
            }
            /*model.read(id: notices[indexPath.row].messageId!).subscribe(onNext:{ [weak self]string in
                if let i = Int(self?.notices[indexPath.row].content ?? "-1") {
                     vc.newsId = i
                 }
                self?.navigationController?.pushViewController(vc, animated: true)
                   }, onError: { error in
                       ProgressHUD.showError()
                   }).disposed(by:disposeBag)*/
        }
    }
}
