//
//  ImageCell.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/10.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "imageCell"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.isHidden = true
        // Initialization code
    }
    


}
