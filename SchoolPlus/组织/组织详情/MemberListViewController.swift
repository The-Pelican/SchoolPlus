//
//  MemberListViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/24.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import Kingfisher
import ProgressHUD

enum MembersType:Int {
    case visitor = 0
    case member = 1
    case none = -1
}


class MemberListViewController: UIViewController {
    var listView:UITableView!
    let memberType:MembersType
    let model = GroupViewModel()
    var organizationId = -1
    var users:[UserInfo] = [] {
        didSet {
            listView.reloadData()
        }
    }
    var my = MyOrganization()
    
    
    init(type:String) {

        switch type {
        case "访客":
            memberType = .visitor
        case "成员":
            memberType = .member
        default:
            memberType = .none
        
        }
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        initNaviBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if memberType == .member {
            getMemberData()
        } else if memberType == .visitor {
            getVisitorData()
        }
    }
    
    func getMemberData() {
         ProgressHUD.show("正在加载中")
        model.memberList = []
        model.getMemberList(organizationId: organizationId).subscribe(onNext:{ string in
            print(string)
            self.users = self.model.memberList
            ProgressHUD.dismiss()
        },onError: { error in
            ProgressHUD.showError()
        })
        model.groupDetail(organizationId: organizationId).subscribe(onNext:{ string in
            self.my = self.model.oneGroup
            ProgressHUD.dismiss()
        },onError: { error in
            ProgressHUD.showError()
        })
    }
    
    func getVisitorData() {
        ProgressHUD.show("正在加载中")
        model.memberList = []
        model.getApplicationList(organizationId: organizationId).subscribe(onNext:{ string in
            self.users = self.model.memberList
            ProgressHUD.dismiss()
        },onError: { error in
            ProgressHUD.showError(error.localizedDescription)
        })
    }
    
    
    
    func initSubView() {
        listView = UITableView()
        listView.frame = self.view.frame
        listView.delegate = self
        listView.dataSource = self
        self.view.addSubview(listView)
    }
    
    func initNaviBar() {
        if memberType == .member {
            title = "成员"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(operation))
        } else if memberType == .visitor {
            title = "申请列表"
        }
        
    }
    
    @objc func operation() {
        print(my.myIdentity)
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        if my.myIdentity! != "FOUNDER" {
            let out = UIAlertAction(title: "退出组织", style: .cancel, handler: {
                [weak self]action in
                self?.model.withdrawMember(organizationId: self?.organizationId ?? -1).subscribe(onNext:{ string in
                    ProgressHUD.showSucceed("退出成功")
                },onError: { error in
                    ProgressHUD.showError()
                })
            })
             alert.addAction(out)
        }
        if my.myIdentity! != "MEMBER" {
            let application = UIAlertAction(title: "部员申请", style: .default, handler: {
                [weak self]action in
                let vc = MemberListViewController(type: "访客")
                vc.organizationId = self?.organizationId ?? -1
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            alert.addAction(application)
        }
         present(alert, animated: true, completion: nil)
    }
   
}

extension MemberListViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = users[indexPath.row].studentName
        if let url = URL(string: users[indexPath.row].avatar ?? "") {
            cell?.imageView?.kf.setImage(with: url)
        }
        return cell!
    }
    
 
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var configuration = UISwipeActionsConfiguration(actions: [])
        
         if memberType == .member && my.myIdentity != "MEMBER" {
            let delete = UIContextualAction(style: .destructive, title: "删除") {
                 [weak self](action, view, completionHandler) in
                 //将对应条目的数据删除
                 self?.model.removeMember(organizationId: self?.organizationId ?? -1, userId: self?.users[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                     self?.users.remove(at: indexPath.row)
                     tableView.reloadData()
                 },onError: { error in
                     print(error)
                     ProgressHUD.showFailed("移除失败")
                 })
                 completionHandler(true)
             }
            configuration =  UISwipeActionsConfiguration(actions: [delete])
        }
        
        if memberType == .visitor {
             let allow = UIContextualAction(style: .destructive, title: "同意") {
                 [weak self](action, view, completionHandler) in
                 //将对应条目的数据删除
                self?.model.applyApplication(organizationId: self?.organizationId ?? -1, userId: self?.users[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
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
               self?.model.rejectApplication(organizationId: self?.organizationId ?? -1, userId: self?.users[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                   ProgressHUD.showSucceed(string)
                self?.users.remove(at: indexPath.row)
               },onError: { error in
                   ProgressHUD.showError(error.localizedDescription)
               })
                completionHandler(true)
            }
            configuration =  UISwipeActionsConfiguration(actions: [allow,reject])
        }
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
