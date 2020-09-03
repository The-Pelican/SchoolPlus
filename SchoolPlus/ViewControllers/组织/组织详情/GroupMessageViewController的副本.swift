//
//  GroupMessageViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/2.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD

class GroupMessageViewController: BaseMessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func create() {
        guard let id = self.organizationId else {
            return
        }
        if user.hasChecked == true {
            let vc = GroupUpdateMessageViewController()
            vc.organizationId = id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            ProgressHUD.showFailed("功能尚未解锁")
        }
    }
    
    override func getData(_ controller: BaseMessageViewController) -> [Infomation] {
        model.getGroupNews(organizationId: organizationId ?? -1).subscribe(onNext:{ [weak self]list in
            self?.messages = list
            self?.model.pageNum += 1
            },onError: { error in
                ProgressHUD.showError(error.localizedDescription)
            }).disposed(by: disposeBag)
        return messages
    }
    


}
