//
//  CatalogueViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/1.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController {
    var listView:UITableView!
    var cataName = ["动态评论","组织申请结果","组织创建结果","关注列表动态提醒","组织申请","动态审核"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        

    }
    
    func initTableView() {
        listView = UITableView(frame: self.view.frame)
        listView.dataSource = self
        listView.delegate = self
        self.view.addSubview(listView)
    }
}

extension CatalogueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cataName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let identifier = "cell"
       var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
       if cell == nil {
           cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
       }
        cell?.textLabel?.text = cataName[indexPath.row]
       return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(InfoViewController(), animated: true)
    }
    
    
}
