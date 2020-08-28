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
    let footer = MJRefreshBackNormalFooter()
    var model = InformationViewModel()
    var comments : [Comment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let disposeBag = DisposeBag()
    var bottomConstraint: Constraint?
    var info =  Infomation(sender:"外研社",date:"2020-07-13",content:"",audioPath:["阿波罗","赫拉"],comment:5,like:5,hasLiked: false, hasSubscribe: false, avartar: "", userId: -1, organizationId: -1,newsId: -1)

    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        initNaviBar()
        initCommentBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.model.comment = []
        model.getNewsComments(id: info.newsId).subscribe(onNext:{ string in
            self.comments = self.model.comment
            self.model.pageNum = self.model.pageNum + 1
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
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
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        self.tableView.mj_footer = footer
        self.view.addSubview(tableView)
    }
    
    func initNaviBar() {
        title = "动态详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(operation))
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
    
    @objc func footerLoad() {
        model.getNewsComments(id: info.newsId).subscribe(onNext:{ string in
            self.comments = self.model.comment
            self.model.pageNum = self.model.pageNum + 1
        }, onError: { error in
            ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        tableView.reloadData()
        self.tableView.mj_footer!.endRefreshing()
    }
    
    @objc func sendMessage() {
        //关闭键盘
        print(textView.text!)
        model.giveComment(newsId: info.newsId, text: textView.text!, pic: pic).subscribe(onNext:{ string in
            ProgressHUD.showSuccess()
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
                print(photo.image) // Final image selected by the user
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
            self.info.deleteNews(newsId: self.info.newsId).subscribe(onNext:{ string in
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
            
            cell.reloadData(sender: info.sender, date: info.date, content: info.content, images: info.audioPath, like: info.like, comment: info.comment, avartar: info.avartar,hasLike: info.hasLiked, hasSubscribed: info.hasSubscribe)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        
        cell.reloadData(sender: comments[indexPath.row].sender, date: comments[indexPath.row].sender, content: comments[indexPath.row].content, audioPath: comments[indexPath.row].audioPath, like: comments[indexPath.row].like, hasLiked: comments[indexPath.row].hasLiked, avartar: comments[indexPath.row].avartar, userId: comments[indexPath.row].userId, newsId: comments[indexPath.row].newsId, commentId: comments[indexPath.row].commentId)
        return cell
    }
}
