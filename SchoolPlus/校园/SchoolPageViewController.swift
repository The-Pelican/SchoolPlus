//
//  SchoolPageViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class SchoolPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let vc = MessagesViewController().view
        vc?.frame = self.view.frame
        if let vc = vc {
            self.view.addSubview(vc)
        }
    }
    



}
