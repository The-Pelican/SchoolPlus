//
//  ListTableViewCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/5.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    static let identifier = "ListTableViewCell"
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var identityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
