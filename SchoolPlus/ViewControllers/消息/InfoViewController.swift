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
    var tableView = UITableView()
    var notices:[Notice] = []{
        didSet{
            for i in notices {
                if i.type != 1 && i.type != 4 {
                    model.read(id: i.messageId!)
                }
            }
            tableView.reloadData()
        }
    }
    let model = InfoViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        initTableView()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.show("正在加载中")
        model.pageNum = 0
        model.notices = []
        model.getNotice().subscribe(onNext:{ [weak self]string in
            self?.notices = self?.model.notices as! [Notice]
            ProgressHUD.dismiss()
        }, onError: { error in
            ProgressHUD.showError()
        }).disposed(by:disposeBag)
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
        self.view.addSubview(tableView)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(notices[indexPath.row].messageId!)
        if notices[indexPath.row].type == 1 || notices[indexPath.row].type == 4 {
            let vc = CommentViewController()
            model.read(id: notices[indexPath.row].messageId!).subscribe(onNext:{ [weak self]string in
                if let i = Int(self?.notices[indexPath.row].content ?? "-1") {
                     vc.newsId = i
                 }
                self?.navigationController?.pushViewController(vc, animated: true)
                   }, onError: { error in
                       ProgressHUD.showError()
                   }).disposed(by:disposeBag)
        }
    }
}
