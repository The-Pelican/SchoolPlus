//
//  GroupTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    static let identifier = "GroupTableViewCell"
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 15;
            frame.origin.y += 10;
            frame.size.height -= 20;
            frame.size.width -= 30;
            super.frame  = frame
        }
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.black.cgColor
        lineView.addButtonLine()
        //initSubView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

    
    
}
