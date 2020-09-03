//
//  ApplicationViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/1.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD

class ApplicationViewController: UIViewController {
    var listView:UITableView!
    let model = GroupViewModel()
    var organizationId = -1
    var list : [UserInfo] = [] {
        didSet {
            for i in list {
                print(i.studentName)
            }
            listView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getVisitorData()
    }
    
    func initSubView() {
        listView = UITableView()
        listView.frame = self.view.frame
        listView.delegate = self
        listView.dataSource = self
        self.view.addSubview(listView)
    }
    
    func getVisitorData() {
        ProgressHUD.show("正在加载中")
        model.memberList = [:]
        model.getApplicationList(organizationId: organizationId).subscribe(onNext:{ list in
            self.list = list
            ProgressHUD.dismiss()
        },onError: { error in
            ProgressHUD.showError(error.localizedDescription)
        })
    }
    
}
extension ApplicationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = list[indexPath.row].studentName
        return cell!
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var configuration = UISwipeActionsConfiguration(actions: [])
        
             let allow = UIContextualAction(style: .destructive, title: "同意") {
                 [weak self](action, view, completionHandler) in
                 //将对应条目的数据删除
                self?.model.applyApplication(organizationId: self?.organizationId ?? -1, userId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                    ProgressHUD.showSucceed(string)
                    
                },onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                })
                 completionHandler(true)
             }
            allow.backgroundColor = UIColor.systemBlue
            
            let reject = UIContextualAction(style: .destructive, title: "拒绝") {
                [weak self](action, view, completionHandler) in
                //将对应条目的数据删除
               self?.model.rejectApplication(organizationId: self?.organizationId ?? -1, userId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                   ProgressHUD.showSucceed(string)
                self?.list.remove(at: indexPath.row)
               },onError: { error in
                   ProgressHUD.showError(error.localizedDescription)
               })
                completionHandler(true)
            }
        configuration =  UISwipeActionsConfiguration(actions: [allow,reject])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
