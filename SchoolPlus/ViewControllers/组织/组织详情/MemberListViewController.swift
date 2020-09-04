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


class MemberListViewController: UIViewController {
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
    var users:[String:[UserInfo]] = [:] {
        didSet {
            for i in users {
                if i.key == "founder" {
                    for j in i.value {
                        list.append(j)
                    }
                }
            }
            for i in users {
                if i.key == "admin"  {
                    for j in i.value {
                        list.append(j)
                    }
                }
            }
            for i in users {
                if i.key == "member" {
                    for j in i.value {
                        list.append(j)
                    }
                }
            }
        }
    }
    
    var my = MyOrganization()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        initNaviBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMemberData()
    }
    
    func getMemberData() {
         ProgressHUD.show("正在加载中")
        list = []
        users = [:]
        model.getMemberList(organizationId: organizationId).subscribe(onNext:{ list in
            self.users = list
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
    
    
    func initSubView() {
        listView = UITableView()
        listView.frame = self.view.frame
        listView.delegate = self
        listView.dataSource = self
        self.view.addSubview(listView)
    }
    
    func initNaviBar() {
            title = "成员"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(operation))
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
                let vc = ApplicationViewController()
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = list[indexPath.row].studentName
        if let url = URL(string: list[indexPath.row].avatar ?? "") {
            cell?.imageView?.kf.setImage(with: url)
        }
        if  indexPath.row == 0 {
            cell?.detailTextLabel?.text = "创始人"
        } else if indexPath.row > 0 && indexPath.row < (users["admin"]!.count + 1) {
             cell?.detailTextLabel?.text = "管理员"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OnthersViewController()
        vc.user = list[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var configuration =  UISwipeActionsConfiguration(actions: [])
        switch my.myIdentity {
        case "ADMIN":
            if indexPath.row < (users["admin"]?.count ?? -1 + 1) {
                let delete = UIContextualAction(style: .destructive, title: "删除") {
                    [weak self](action, view, completionHandler) in
                    //将对应条目的数据删除
                    self?.model.removeMember(organizationId: self?.organizationId ?? -1, userId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                        self?.list.remove(at: indexPath.row)
                        tableView.reloadData()
                    },onError: { error in
                        print(error)
                        ProgressHUD.showFailed("移除失败")
                    })
                    completionHandler(true)
                }
                configuration =  UISwipeActionsConfiguration(actions: [delete])
            }
        case "FOUNDER":
            let delete = UIContextualAction(style: .destructive, title: "删除") {
                [weak self](action, view, completionHandler) in
                //将对应条目的数据删除
                guard indexPath.row != 0 else {return}
                self?.model.removeMember(organizationId: self?.organizationId ?? -1, userId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                    self?.list.remove(at: indexPath.row)
                    tableView.reloadData()
                },onError: { error in
                    print(error)
                    ProgressHUD.showFailed("移除失败")
                })
                completionHandler(true)
            }
            let tell = UIContextualAction(style: .normal, title: "任命管理员") {
                [weak self](action, view, completionHandler) in
                //将对应条目的数据删除
                guard indexPath.row > self?.users["admin"]?.count ?? 10000000 + 1 else {return}
                self?.model.chooseNewAdmin(organizationId: self?.organizationId ?? -1, adminId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                    if string == "success" {
                        ProgressHUD.showSucceed()
                    } else {
                        ProgressHUD.showFailed(string)
                    }
                },onError: { error in
                    print(error)
                    ProgressHUD.showFailed("移除失败")
                })
                completionHandler(true)
            }
            configuration =  UISwipeActionsConfiguration(actions: [delete,tell])
        default:
            configuration = UISwipeActionsConfiguration(actions: [])
        }
       /* if  my.myIdentity != "MEMBER" && indexPath.row != 0 {
            let delete = UIContextualAction(style: .destructive, title: "删除") {
                [weak self](action, view, completionHandler) in
                //将对应条目的数据删除
                self?.model.removeMember(organizationId: self?.organizationId ?? -1, userId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                    self?.list.remove(at: indexPath.row)
                    tableView.reloadData()
                },onError: { error in
                    print(error)
                    ProgressHUD.showFailed("移除失败")
                })
                completionHandler(true)
            }
            configuration =  UISwipeActionsConfiguration(actions: [delete])
        }
        
        if  my.myIdentity == "FOUNDER" {
            let tell = UIContextualAction(style: .normal, title: "任命管理员") {
                [weak self](action, view, completionHandler) in
                //将对应条目的数据删除
                self?.model.chooseNewAdmin(organizationId: self?.organizationId ?? -1, adminId: self?.list[indexPath.row].userId ?? -1).subscribe(onNext:{ string in
                    if string == "success" {
                        ProgressHUD.showSucceed()
                    } else {
                        ProgressHUD.showFailed(string)
                    }
                },onError: { error in
                    print(error)
                    ProgressHUD.showFailed("移除失败")
                })
                completionHandler(true)
            }
            configuration =  UISwipeActionsConfiguration(actions: [tell])
        }*/
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
