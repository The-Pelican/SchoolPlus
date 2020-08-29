//
//  NoticeDetailViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.frame = self.view.frame
        textView.isEditable = false
        self.view.addSubview(textView)
    }
    

   

}
