//
//  CatalogueViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/1.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD
import RxSwift


class CatalogueViewController: UIViewController {
    let model = InfoViewModel()
    var notices = [Int:[Notice]]() {
        didSet {
            listView.reloadData()
            print("vc:\(notices)")
        }
    }
    let disposeBag = DisposeBag()
    var listView:UITableView!
    var cataName = ["动态评论","组织申请结果","组织创建结果","关注列表动态提醒","组织申请","动态审核"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.model.notices = [1:[Notice](),2:[Notice](),3:[Notice](),4:[Notice](),5:[Notice](),6:[Notice]()]
        self.model.pageNum = 0
        /*model.getNotice().subscribe(onNext:{ notices in
            self.notices = self.model.notices
            ProgressHUD.dismiss()
        },onError: { error in
            }).disposed(by: disposeBag)*/
        
        /*model.unread().subscribe(onNext:{ string in
            print("read")
            let window = Navigator.window()
            if let vc = window.rootViewController as? MainTabViewController {
                vc.infoItem.badgeValue = string
                if  string == "0" {
                    vc.infoItem.badgeValue = nil
                }
            }
        },onError: { error in
            ProgressHUD.showFailed(error.localizedDescription)
            }).disposed(by: disposeBag)*/
    }
    
    func initTableView() {
        listView = UITableView(frame: self.view.frame)
        listView.dataSource = self
        listView.delegate = self
        listView.register(UINib(nibName: "MessageTypeTableViewCell", bundle: nil), forCellReuseIdentifier: MessageTypeTableViewCell.identifier)
        self.view.addSubview(listView)
    }
}

extension CatalogueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cataName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTypeTableViewCell.identifier, for: indexPath) as! MessageTypeTableViewCell
       
        cell.typeLabel.text = cataName[indexPath.row]
        /*for (key,value) in notices {
            if indexPath.row == (key-1) {
                cell.contentLabel.text = value.first?.content
                if let date = (value.first?.time) {
                    cell.dateLabel.text = timeIntervalToString(timeInterval: Double(date))
                }
            }
        }*/
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InfoViewController()
        vc.typeIndex = indexPath.row + 1
        vc.notices = notices[indexPath.row + 1] ?? [Notice]()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
