//
//  SubscribeMessageViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/2.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD

class SubscribeMessageViewController: BaseMessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func getData(_ controller: BaseMessageViewController) -> [Infomation] {
        model.getSubscribeData().subscribe(onNext:{ [weak self]list in
            self?.messages = list
            self?.model.pageNum  += 1
            ProgressHUD.dismiss()
            },onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        return messages
    }

   

}
