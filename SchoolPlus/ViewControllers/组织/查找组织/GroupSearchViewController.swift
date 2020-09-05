//
//  GroupSearchViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import RxSwift
import ProgressHUD
import Kingfisher

class GroupSearchViewController: UIViewController {
    let model = GroupViewModel()
    var tableView =  UITableView()
    var searchController = UISearchController()
    var button = UIButton()
    var groups = [Organization]() {
        didSet {
            tableView.reloadData()
        }
    }
    var recommendGroups = [Organization]() {
        didSet {
            tableView.reloadData()
        }
    }
    var searchGroup = [Organization]() {
        didSet{self.tableView.reloadData()}
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
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
        getData()
    }
    
    func getData() {
        print("getdata")
        model.groups = []
        model.recommendGroup = []
        model.searchGroup = []
        if user.hasChecked ?? false {
            model.getMyGroups().subscribe(onNext:{ string in
                self.groups = self.model.groups
                self.recommendGroups = self.model.recommendGroup
            },onError:{ error in
                ProgressHUD.showError()
                }).disposed(by: disposeBag)
        }
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
        searchController.searchBar.delegate = self  //两个样例使用不同的代理
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
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
        if user.hasChecked != true {
            ProgressHUD.showFailed("功能尚未解锁")
            return
        }
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
            if section == 0 {
                return self.groups.count
            }
            return self.recommendGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as! GroupTableViewCell
         if self.searchController.isActive {
            cell.nameLabel?.text = self.searchGroup[indexPath.row].organizationName
            cell.contentLabel?.text = self.searchGroup[indexPath.row].intro
            if let url = URL(string: self.searchGroup[indexPath.row].logo ?? "") {
                cell.logoView.kf.setImage(with:url)
            }
            return cell
         } else {
            if indexPath.section == 0 {
                cell.nameLabel?.text = self.groups[indexPath.row].organizationName
                cell.contentLabel?.text = self.groups[indexPath.row].intro
                if let url = URL(string: self.groups[indexPath.row].logo ?? "") {
                               cell.logoView.kf.setImage(with:url)
                           }
            } else if indexPath.section == 1 {
                cell.nameLabel?.text = self.recommendGroups[indexPath.row].organizationName
                cell.contentLabel?.text = self.recommendGroups[indexPath.row].intro
                if let url = URL(string: self.recommendGroups[indexPath.row].logo ?? "") {
                    cell.logoView.kf.setImage(with:url)
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if user.hasChecked != true {
            ProgressHUD.showFailed("功能尚未解锁")
            return
        }
        let vc = GroupDetailViewController()
        if self.searchController.isActive {
            vc.organizationId = self.searchGroup[indexPath.row].organizationId ?? -1
        } else {
            if indexPath.section == 0 {
                vc.organizationId = self.groups[indexPath.row].organizationId ?? -1
            } else {
                vc.organizationId = self.recommendGroups[indexPath.row].organizationId ?? -1
            }
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GroupSearchViewController:UISearchBarDelegate {

    /*func updateSearchResults(for searchController: UISearchController) {
        model.searchGroup = []
        model.searchGroups(text: searchController.searchBar.text!).subscribe(onNext:{ [weak self]string in
            print(string)
            self?.searchGroup = self?.model.searchGroup as! [Organization]
        },onError: { error in
            ProgressHUD.showError()
            
        })
        /*self.searchGroup = self.groups.filter({ (group) -> Bool in
            return group.name.contains(searchController.searchBar.text!)
            })*/
    }*/
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        model.searchGroup = []
        model.searchGroups(text: searchController.searchBar.text!).subscribe(onNext:{ [weak self]string in
            print(string)
            self?.searchGroup = self?.model.searchGroup as! [Organization]
        },onError: { error in
            ProgressHUD.showError()
            
            }).disposed(by: disposeBag)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //self.searchGroup = self.groups
        getData()
    }
    
}
