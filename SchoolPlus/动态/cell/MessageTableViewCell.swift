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
    
    var info = Infomation()
    let disposeBag = DisposeBag()
    
    var images:[String] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCollectionView()
        subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
        subscribeButton.layer.cornerRadius = 5
        likeButton.addTarget(self, action: #selector(likeNews), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(subscribe), for: .touchUpInside)
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
        if info.hasLiked {
            info.dislikeNews(id:info.newsId).subscribe(onNext:{ string in
                self.likeButton.setTitle("🖤", for: .normal)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        } else {
            info.likeNews(id:info.newsId).subscribe(onNext:{ string in
                self.likeButton.setTitle("💗", for: .normal)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        }
    }
    
    @objc func subscribe() {
        if !info.hasSubscribe {
            user.subscribeUser(userId: info.userId, organizationId: info.organizationId).subscribe(onNext:{ string in
                self.subscribeButton.backgroundColor = UIColor.darkGray
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            user.cancelSubscribe(userId: info.userId, organizationId: info.organizationId).subscribe(onNext:{ string in
                self.subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        }
    }
    
    
    
    func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView!.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
    }
    
    func reloadData(sender:String,date:String,content:String,images:[String],like:Int,comment:Int,avartar:String,hasLike:Bool,hasSubscribed:Bool) {
        self.userNameLabel.text = sender
        self.dateLabel.text = date
        self.contentLabel.text = content
        self.images = images
        self.commentButton.setTitle("💬\(comment)", for: .normal)

        if let url = URL(string:avartar) {
            head.kf.setImage(with: url)
        } else {
            head.backgroundColor = UIColor.black
        }
        
        if hasLike {
            self.likeButton.setTitle("💗\(like)", for: .normal)
        } else {
            self.likeButton.setTitle("🖤\(like)", for: .normal)
        }
        
        if hasSubscribed {
            self.subscribeButton.backgroundColor = UIColor.darkGray
        } else {
            self.subscribeButton.backgroundColor = UIColor(valueStr: "FBEA77")
        }
        
        
        self.collectionView.reloadData()
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        collectionViewHeight.constant = contentSize.height
        if images.count == 0 {
            collectionViewHeight.constant = 1
        }
                 
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
