//
//  TimeLineTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/23.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    var timeLineIcon: UIImageView!
    var thumbnailView: UIImageView!
    var nameLabel: UILabel!
    var dateLabel: UILabel!
    var containView: UIView!
    var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
