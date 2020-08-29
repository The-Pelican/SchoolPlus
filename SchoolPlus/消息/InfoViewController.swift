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
        model.pageNum = 0
        model.notices = []
        model.getNotice().subscribe(onNext:{ [weak self]string in
            self?.notices = self?.model.notices as! [Notice]
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
        model.read(id: notices[indexPath.row].messageId!).subscribe(onNext:{ [weak self]string in
            let vc = NoticeDetailViewController()
            vc.textView.text = self?.notices[indexPath.row].content ?? "加载失败"
            self?.navigationController?.pushViewController(vc, animated: true)
        }, onError: { error in
            ProgressHUD.showError()
        }).disposed(by:disposeBag)
    }
}
