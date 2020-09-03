//
//  CommentViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/22.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import ProgressHUD
import MJRefresh
import YPImagePicker



class CommentViewController: UIViewController {
    var tableView:UITableView!
    var sendButton = UIButton()
    var whiteView = UIView()
    var textView = UITextView()
    var chooseButton = UIButton()
    var pic = UIImage()
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshBackNormalFooter()
    var model = InformationViewModel()
    var comments : [Comment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let disposeBag = DisposeBag()
    var bottomConstraint: Constraint?
    var newsId = -1
    var info =  Infomation() {
        didSet {
            tableView.reloadData()
            if judgeGroup() {
                 navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                let userId = info.publisher?.userId ?? -2
                let organizationId = info.orgnization?.organizationId ?? -2
                if  (user.userId != userId) && (user.userId != organizationId){
                    navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        initNaviBar()
        initCommentBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.show("正在加载中")
        model.getOneNews(newsId: newsId).subscribe(onNext:{ string in
            self.info = self.model.oneMessage
            ProgressHUD.dismiss()
        },onError: { error in
            ProgressHUD.showError()
        }).disposed(by: disposeBag)
        
        
        self.model.pageNum = 0
        self.model.comment = []
        model.getNewsComments(id: newsId).subscribe(onNext:{ string in
            self.comments = self.model.comment
            self.model.pageNum = self.model.pageNum + 1
            ProgressHUD.dismiss()
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        //judge()
    }
    
    func initSubView() {
        self.view.backgroundColor = UIColor.blue
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        let nib1 = UINib(nibName: "MessageTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: MessageTableViewCell.identifier)
        tableView.register(nib, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.sectionHeaderHeight = 10
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_header = header
        header.setTitle("下拉可以刷新", for: .idle)
        header.setTitle("正在刷新中", for: .refreshing)
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        self.tableView.mj_footer = footer
        self.view.addSubview(tableView)
    }
    
    func initNaviBar() {
        title = "动态详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(operation))
    }
    
    //根据数据要求判断禁用条件
    func judgeGroup() -> Bool {
        print("判断")
        var index = 0
        if let vcs = self.navigationController?.viewControllers {
            print("获得")
            for i in 0 ..< vcs.count {
                print(vcs[i])
                if self == vcs[i] {
                   index = i
                    print(i)
                }
            }
            
            if let vc = vcs[index-1] as? GroupMessageViewController {
                print("组织动态")
                navigationItem.rightBarButtonItem?.isEnabled = true
                return true
            }
        }
        return false
    }
    
    func initCommentBar() {
        whiteView.backgroundColor = UIColor.white
        self.view.addSubview(whiteView)
        whiteView.snp.makeConstraints({(make) -> Void in
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
            self.bottomConstraint = make.bottom.equalTo(self.view).constraint
        })
        
        sendButton.setTitle("发送", for: .normal)
        sendButton.layer.cornerRadius = 5
        sendButton.setTitleColor(UIColor.white,for: .normal)
        sendButton.backgroundColor=UIColor.orange
        sendButton.addTarget(self,action:#selector(sendMessage),for:.touchUpInside)
        whiteView.addSubview(sendButton)
        
        sendButton.snp.makeConstraints({
            $0.width.equalTo(60)
            $0.height.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        })
        
        chooseButton.setTitle("📷", for: .normal)
        chooseButton.addTarget(self, action: #selector(addPic), for: .touchUpInside)
        whiteView.addSubview(chooseButton)
        chooseButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(5)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
            $0.centerY.equalToSuperview()
        })
        
        textView.backgroundColor = UIColor.lightGray
        textView.layer.cornerRadius = 5
        whiteView.addSubview(textView)
        textView.snp.makeConstraints({
            $0.left.equalTo(chooseButton.snp.right)
            $0.right.equalTo(sendButton.snp.left).offset(-10)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
        })
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(keyboardWillChange(_:)),
        name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
             
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
             
    
            self.bottomConstraint?.updateOffset(amount: -intersection.height)
             
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIView.AnimationOptions(rawValue: curve), animations: {
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func headerRefresh(){
        self.model.pageNum = 0
        self.model.comment = []
        model.getNewsComments(id: (info.newsId)!).subscribe(onNext:{ string in
            self.comments = self.model.comment
            self.model.pageNum = self.model.pageNum + 1
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        tableView.reloadData()
        self.tableView.mj_header!.endRefreshing()
    }
    
    
    @objc func footerLoad() {
        model.getNewsComments(id: (info.newsId)!).subscribe(onNext:{ string in
            self.comments = self.model.comment
            self.model.pageNum = self.model.pageNum + 1
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        tableView.reloadData()
        self.tableView.mj_footer!.endRefreshing()
    }
    
    @objc func sendMessage() {
        guard user.hasChecked == true else {
            ProgressHUD.showFailed("功能尚未解锁")
            return
        }
        print(textView.text!)
        guard !((textView.text)!.isEmpty) else {return}
        model.giveComment(newsId: info.newsId!, text: textView.text!, pic: pic).subscribe(onNext:{ string in
            if string == "success" {
                ProgressHUD.showSuccess()
            } else {
                ProgressHUD.showFailed(string)
            }
            
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        textView.resignFirstResponder()
    }
    
    @objc func addPic() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.pic = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc func operation() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let edit = UIAlertAction(title: "编辑", style: .default) {
            _ in
            let vc = UpdateMessageViewController()
            vc.info = self.info
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let delete = UIAlertAction(title: "删除", style: .default) {
            _ in
            self.info.deleteNews(newsId: self.info.newsId!).subscribe(onNext:{ string in
                ProgressHUD.showSucceed()
                self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: self.disposeBag)
        }
        alert.addAction(cancel)
        alert.addAction(edit)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }

}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        initCommentBar()
        textView.becomeFirstResponder()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
            
            cell.frame = tableView.bounds
            cell.layoutIfNeeded()
            cell.info = info
            cell.reloadData( date: info.publishTime ?? "00000000", content: info.text ?? "", images: info.media ?? [String](), like: info.likesNum ?? 0, comment:info.commentsNum ?? 0, hasLike: info.hasLiked ?? false)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        
        cell.comment = comments[indexPath.row]
        cell.reloadData(sender: (comments[indexPath.row].userInfo?.studentName) ?? "", date: "\(comments[indexPath.row].commentTime ?? 20202020)", content: comments[indexPath.row].text ?? "", audioPath: comments[indexPath.row].pic ?? "", like: comments[indexPath.row].likesNum ?? 0, hasLiked: comments[indexPath.row].hasLiked!, avartar: (comments[indexPath.row].userInfo?.avatar)!, userId: (comments[indexPath.row].userInfo?.userId)!, newsId: comments[indexPath.row].newsId!, commentId: comments[indexPath.row].commentId!)
        return cell
    }
}
