//
//  CommentTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/21.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "commentCell"
    var comment = Comment()

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var cotentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func reloadData(sender:String,date:String,content:String,audioPath:String,like:Int,hasLiked:Bool,avartar:String, userId:Int,newsId:Int,commentId:Int) {
        self.nameLabel.text = sender
        self.dateLabel.text = date
        self.cotentLabel.text = content
        self.likeButton.setTitle("💗\(like)", for: .normal)
        if let url = URL(string:avartar) {
            logoView.kf.setImage(with: url)
        } else {
            logoView.backgroundColor = UIColor.black
        }
    }
    
}
