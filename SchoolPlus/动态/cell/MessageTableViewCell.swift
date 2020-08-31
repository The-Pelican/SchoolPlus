//
//  MessageTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/10.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import ProgressHUD

class MessageTableViewCell: UITableViewCell {
    static let identifier = "messageTableViewCell"
    @IBOutlet weak var head: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var info:Infomation? {
        didSet {
            if let publisher = info?.publisher?.studentName {
                let i = (info?.publisher)!
                userNameLabel.text = i.studentName
                if let url = URL(string:i.avatar ?? "") {
                      head.kf.setImage(with: url)
                  }
                if i.hasSubscribed ?? false {
                    self.subscribeButton.backgroundColor = UIColor.darkGray
                } else {
                    self.subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
                }
                if i.userId == user.userId {
                    self.subscribeButton.isHidden = true
                } else {
                    self.subscribeButton.isHidden = false
                }
            }
            
            if let organization = info?.orgnization?.organizationName {
                let i = (info?.orgnization)!
                userNameLabel.text = i.organizationName
                if i.hasSubscribed ?? false {
                    self.subscribeButton.backgroundColor = UIColor.darkGray
                } else {
                    self.subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
                }
            }
        }
    }
    let disposeBag = DisposeBag()
    
    var images:[String] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCollectionView()
        subscribeButton.layer.cornerRadius = 5
        likeButton.addTarget(self, action: #selector(likeNews), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(subscribe), for: .touchUpInside)
        head.layer.cornerRadius = head.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.size.height -= 10
            frame.origin.y += 10
            super.frame  = frame
        }
    }
    
    @objc func likeNews() {
        guard user.hasChecked == true else {
            ProgressHUD.showFailed("功能尚未解锁")
            return
        }
        if let info = info {
            print(info.likesNum!)
            print((info.newsId)!)
            if info.hasLiked! {
                info.dislikeNews(id:(info.newsId)!).subscribe(onNext:{ string in
                    self.likeButton.setTitle("🖤\(info.likesNum!-1)", for: .normal)
                    info.likesNum! -= 1
                    info.hasLiked = false
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            } else {
                info.likeNews(id:(info.newsId)!).subscribe(onNext:{ string in
                    self.likeButton.setTitle("💗\(info.likesNum!+1)", for: .normal)
                    info.hasLiked = true
                    info.likesNum! += 1
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            }
        }
    }
    
    @objc func subscribe() {
        guard user.hasChecked == true else {
            ProgressHUD.showFailed("功能尚未解锁")
            return
        }
        
        guard let info = info else {
            print("info为nil")
            return
        }
        if let n = info.publisher?.hasSubscribed  {
            if n {
                user.cancelSubscribe(userId: info.publisher?.userId!, organizationId: nil).subscribe(onNext:{ string in
                self.subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
                    info.publisher?.hasSubscribed = false
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            } else {
                user.subscribeUser(userId: (info.publisher?.userId)!).subscribe(onNext:{ string in
                self.subscribeButton.backgroundColor = UIColor.darkGray
                    info.publisher?.hasSubscribed = true
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            }
        }

        if let i = info.orgnization?.hasSubscribed {
            if i {
                user.cancelSubscribe(userId: nil, organizationId: info.orgnization?.organizationId!).subscribe(onNext:{ string in
                   self.subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
                    info.orgnization?.hasSubscribed = false
                   }, onError: { error in
                       ProgressHUD.showError(error.localizedDescription)
                   }).disposed(by: disposeBag)
            } else {
                user.subscribeOragnization(organizationId: (info.orgnization?.organizationId)!).subscribe(onNext:{ string in
                self.subscribeButton.backgroundColor = UIColor.darkGray
                    info.orgnization?.hasSubscribed = true
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            }
        }

      
    }
    
    
    
    func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    func reloadData(date:String,content:String,images:[String],like:Int,comment:Int,hasLike:Bool) {
        self.dateLabel.text = date
        self.contentLabel.text = content
        self.images = images
        self.commentButton.setTitle("💬\(comment)", for: .normal)
        if hasLike {
            self.likeButton.setTitle("💗\(like)", for: .normal)
        } else {
            self.likeButton.setTitle("🖤\(like)", for: .normal)
        }
        self.collectionView.reloadData()
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        collectionViewHeight.constant = contentSize.height
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
}

extension MessageTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
 
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        if let url = URL(string:images[indexPath.row]) {
            cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.backgroundColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击collectionview")
        var realImages:[UIImage] = []
        for image in images {
            if let url = URL(string: image) {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        realImages.append(image)
                    }
                }catch let error as NSError {
                    print(error)
                }
            }
        }
        let previewVC = ImageDetailViewController(images: realImages)
        let vc = firstViewController()
        vc?.navigationController?.pushViewController(previewVC, animated: true)
    }
}
