//
//  CommentTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/21.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD
import RxSwift

class CommentTableViewCell: UITableViewCell {
    static let identifier = "commentCell"
    var comment: Comment? 

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cotentLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func reloadData(sender:String,date:String,content:String,audioPath:String,like:Int,hasLiked:Bool,avartar:String, userId:Int,newsId:Int,commentId:Int) {
        self.nameLabel.text = sender
        if let timeInterval = Double(date) {
            self.dateLabel.text = timeIntervalToString(timeInterval: timeInterval)
        }
        
        
        self.cotentLabel.text = content
        if hasLiked {
            self.likeButton.setTitle("💗\(like)", for: .normal)
        } else {
            self.likeButton.setTitle("🖤\(like)", for: .normal)
        }
        
        if let url = URL(string:avartar) {
            logoView.kf.setImage(with: url)
        } else {
            logoView.backgroundColor = UIColor.black
        }
    }
    
    @objc func likeComment() {
        guard user.hasChecked == true else {
            ProgressHUD.showFailed("功能尚未解锁")
            return
        }
        if let comment = comment {
            if comment.hasLiked! {
                user.dislikeComment(commentId:(comment.commentId)!).subscribe(onNext:{ string in
                    self.likeButton.setTitle("🖤\(comment.likesNum!-1)", for: .normal)
                    comment.likesNum! -= 1
                    comment.hasLiked = false
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            } else {
                user.likeComment(commentId:(comment.commentId)!).subscribe(onNext:{ string in
                    self.likeButton.setTitle("💗\(comment.likesNum!+1)", for: .normal)
                    comment.likesNum! += 1
                    comment.hasLiked = true
                }, onError: { error in
                    ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
            }
        }

    }
    
}
