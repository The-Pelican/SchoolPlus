//
//  InfoDetailViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/27.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import Kingfisher

class InfoDetailViewController: UIViewController {
    var listView:UITableView!
    var users:[UserInfo] = []
    var groups:[Organization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        initSubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initSubView() {
        listView = UITableView()
        listView.frame = self.view.frame
        listView.delegate = self
        listView.dataSource = self
        self.view.addSubview(listView)
    }
    
}

extension InfoDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.isEmpty {
            return groups.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let identifier = "cell"
           var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
           if cell == nil {
               cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
           }
        if users.isEmpty {
            cell?.textLabel?.text = groups[indexPath.row].organizationName
            if let url = URL(string: groups[indexPath.row].logo ?? "") {
                cell?.imageView?.kf.setImage(with: url)
            }
            
        } else {
            cell?.textLabel?.text = users[indexPath.row].studentName
            if let url = URL(string: users[indexPath.row].avatar ?? "") {
                cell?.imageView?.kf.setImage(with: url)
            }
        }
           return cell!
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !groups.isEmpty {
            let vc = GroupDetailViewController()
            vc.organizationId = groups[indexPath.row].organizationId ?? -1
            self.navigationController?.pushViewController(vc, animated: true)
        } else if !users.isEmpty {
            let vc = OnthersViewController()
            vc.user = users[indexPath.row]
            vc.userId = users[indexPath.row].userId!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


