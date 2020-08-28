//
//  MemberListViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/24.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController {
    var memberLabel:UILabel!
    var editButton:UIButton!
    var listView:UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension MemberListViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = "成员"
        return cell!
    }
}
