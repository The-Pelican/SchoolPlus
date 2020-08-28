//
//  GroupSearchViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class GroupSearchViewController: UIViewController {
    let model = GroupViewModel()
    var tableView =  UITableView()
    var searchController = UISearchController()
    var button = UIButton()
    var groups = [Organization]()
    var searchGroup = [Organization]() {
        didSet{self.tableView.reloadData()}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let group = Organization()
        group.name = "西二在线"
        group.slogan = "我在西二，为你在线"
        group.description = "西二在线，成立于1998年。是集美貌与智慧于一身的历史最悠久最酷炫最强大的学生组织"
        group.founder = "？？？"
        group.memberCount = 29
        let group1 = Organization()
        group1.name = "DBL街舞协会"
        group1.description = "大菠萝"
        groups.append(group)
        groups.append(group1)
        initTableView()
        initSearchController()
        initButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    func initTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: GroupTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GroupTableViewCell.identifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.centerX.left.top.equalToSuperview()
            $0.height.equalTo(self.view.frame.height-90)
        })
    }
    func initSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "寻找感兴趣的组织"
        tableView.tableHeaderView = searchController.searchBar
    }
    func initButton() {
        button.setTitle("创建一个组织", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 3,height: 3)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.init(valueStr: "FBEA77").cgColor
        button.backgroundColor = UIColor(valueStr: "FBEA77")
        button.addTarget(self, action: #selector(create), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.bottom)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        })
    }
    
    @objc func create() {
        let vc = CreateGroupViewController()
        vc.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GroupSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchController.isActive {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !searchController.isActive {
            if section == 0 {
                return "我的所有组织"
            } else {
                return "学校其他组织"
            }
        }
        return "搜索结果"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive {
            return self.searchGroup.count
           
        } else {
            return self.groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as! GroupTableViewCell
         if self.searchController.isActive {
            cell.nameLabel?.text = self.searchGroup[indexPath.row].name
            cell.contentLabel?.text = self.searchGroup[indexPath.row].description
            return cell
         } else {
            cell.nameLabel?.text = self.groups[indexPath.row].name
            cell.contentLabel?.text = self.groups[indexPath.row].description
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = GroupDetailViewController()
        vc.group = groups[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GroupSearchViewController:UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        model.searchGroups(text: searchController.searchBar.text!)
        /*self.searchGroup = self.groups.filter({ (group) -> Bool in
            return group.name.contains(searchController.searchBar.text!)
            })*/
    }
    
}
