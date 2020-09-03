//
//  GroupUpdateMessageViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/9/3.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import ProgressHUD

class GroupUpdateMessageViewController: UpdateMessageViewController {
    let model = GroupViewModel()
    var organizationId = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func uploadMessage() {
        if let info = info {
            print("编辑")
            print(info.newsId!)
            print(newImages)
            print(info.media!)
            ProgressHUD.show("正在加载中")
            model.editNews(newsId:info.newsId!,text: textView.text!, media: info.media!,files:newImages).subscribe(onNext:{ string in
                guard string == "success" else {
                    ProgressHUD.dismiss()
                    ProgressHUD.show(string)
                    return
                }
                    ProgressHUD.dismiss()
                    ProgressHUD.showSucceed()
                    self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        } else {
            model.uploadNews(organizationId:organizationId,text: textView.text!, pic: images).subscribe(onNext:{ string in
                guard string == "success" else {
                    ProgressHUD.show(string)
                    return
                }
                ProgressHUD.showSucceed()
                self.navigationController?.popViewController(animated: true)
            }, onError: { error in
                ProgressHUD.showError(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
    }
    


}
