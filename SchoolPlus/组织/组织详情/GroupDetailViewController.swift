//
//  GroupDetailViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/23.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import ProgressHUD

class GroupDetailViewController: UIViewController {
    var group = MyOrganization() {
        didSet {
            nameLabel.text = "名称：\(group.organizationInfo?.organizationName ?? "name nil")"
            if let url = URL(string: group.organizationInfo?.logo ?? "logourl") {
                logo.kf.setImage(with: url)
            }
            sloganLabel.text = "Slogan：\(group.organizationInfo?.slogan ?? "slogo nil")"
            descriptionContentLabel.text = group.organizationInfo?.intro ?? "intro nil"
        }
    }
    let model = GroupViewModel()
    var news = [Infomation]() {
        didSet {
            messageView.reloadData()
        }
    }
    var organizationId = -1
    var logo = UIImageView()
    var detail = UIView()
    let nameLabel = UILabel()
    let sloganLabel = UILabel()
    let nameContentLabel = UILabel()
    let sloganContentLabel = UILabel()
    let descriptionLabel = UILabel()
    let descriptionContentLabel = UILabel()
    let founderLabel = UILabel()
    let founderContentLabel = UILabel()
    let counterLabel = UILabel()
    let counterContentLabel = UILabel()
    var messageLabel = UILabel()
    var messageView = UITableView()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()

    }
    
    func getData() {
        model.groupNews = []
        model.pageNum = 0
        model.groupDetail(organizationId:organizationId).subscribe(onNext:{ [weak self]string in
            self?.group = self?.model.oneGroup as! MyOrganization
        },onError:{ error in
            ProgressHUD.showError()
            }).disposed(by: disposeBag)
        
        model.getGroupNews(organizationId: organizationId).subscribe(onNext:{ [weak self]string in
            self?.news = self?.model.groupNews as! [Infomation]
        },onError:{ error in
            ProgressHUD.showError()
            }).disposed(by: disposeBag)
    }
    
    func initSubView() {
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let addButton = UIBarButtonItem(title: "...", style: .plain, target: self, action: nil)
        addButton.action = #selector(checkIdentity)
        navigationItem.rightBarButtonItem = addButton
        
        logo.backgroundColor = UIColor.black
        logo.layer.cornerRadius = 30
        logo.clipsToBounds = true
        self.view.addSubview(logo)
        logo.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(100)
            $0.height.equalTo(60)
            $0.width.equalTo(60)
        })
        
        detail.layer.borderWidth = 1
        detail.layer.borderColor = UIColor.black.cgColor
        detail.layer.cornerRadius = 5
        self.view.addSubview(detail)
        detail.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logo.snp.bottom).offset(15)
            $0.left.equalTo(28)
            $0.height.equalTo(200)
        })
        
        nameLabel.text = "名称：  "
        self.detail.addSubview(nameLabel)
        nameLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(5)
            $0.width.equalTo(300)
        })
        
        sloganLabel.text = "Slogan："
        self.detail.addSubview(sloganLabel)
        sloganLabel.snp.makeConstraints({
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.equalTo(5)
            $0.width.equalTo(300)
        })
        
        descriptionLabel.text = "简介:"
        self.detail.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints({
            $0.top.equalTo(sloganLabel.snp.bottom).offset(20)
            $0.left.equalTo(5)
        })
        
        descriptionContentLabel.text = ""
        descriptionContentLabel.numberOfLines = 0
        self.detail.addSubview(descriptionContentLabel)
        descriptionContentLabel.snp.makeConstraints({
            $0.top.equalTo(sloganLabel.snp.bottom).offset(20)
            $0.left.equalTo(descriptionLabel.snp.right).offset(5)
            $0.width.equalTo(300)
        })
        
        
        messageLabel.text = "动态"
        messageLabel.textAlignment = .center
        self.view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(detail.snp.bottom).offset(20)
        })
        
        messageView.backgroundColor = UIColor.white
        messageView.delegate = self
        messageView.dataSource = self
        messageView.separatorStyle = .none
        let nib = UINib(nibName: "TimeLineTableViewCell", bundle: nil)
        messageView.register(nib, forCellReuseIdentifier: TimeLineTableViewCell.identifier)
        self.view.addSubview(messageView)
        messageView.snp.makeConstraints({
            $0.top.equalTo(messageLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(500)
            $0.width.equalTo(400)
        })
    }
    
    @objc func checkIdentity() {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        if group.myIdentity == "VISITOR"{
            let join = UIAlertAction(title: "加入组织", style: .default, handler: { [weak self]action in
                self?.model.applyForMember(organizationId: self?.organizationId ?? -1).subscribe(onNext:{ string in
                    if string == "success" {
                        ProgressHUD.showSucceed("已发送申请")
                    } else {
                        ProgressHUD.showFailed("申请提交失败")
                    }
                },onError: { error in
                    ProgressHUD.showFailed("申请提交失败")
                })
            })
            alert.addAction(join)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let newsEdit = UIAlertAction(title: "动态相关", style: .default, handler: { action in
            
        })
        let memManage = UIAlertAction(title: "成员相关", style: .default, handler: { action in
            let vc = MemberListViewController(type: "成员")
            vc.organizationId = self.organizationId
            self.navigationController?.pushViewController(vc, animated: true)
        })

        switch group.myIdentity! {
        case "MEMBER":
            alert.addAction(memManage)
        default:
            alert.addAction(memManage)
            alert.addAction(newsEdit)
        }
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension GroupDetailViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineTableViewCell.identifier,for: indexPath) as! TimeLineTableViewCell
        cell.dateLabel.text = news[indexPath.row].publishTime
        cell.contentLabel.text = "\(news[indexPath.row].text ?? "content nil")\n \n \n"
        if let imageStr = news[indexPath.row].media?.first {
            if let url = URL(string: imageStr) {
                cell.picView.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    
}
