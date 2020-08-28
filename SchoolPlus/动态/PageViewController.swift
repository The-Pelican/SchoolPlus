//
//  PageViewController.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/25.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

public enum UserAction: Int {
    case none = 0
    case tap = 1
    case swipe = 2
}

class PageViewController: UIViewController,UIPageViewControllerDelegate {
    var scrollView = UIScrollView()
    var vc : [MessagesViewController] = [MessagesViewController(type: "全部"),MessagesViewController(type:"已关注")]
    var tabView = UIView()
    var tabHeight = CGFloat(100)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }

    func initSubView() {
        let pageWidth = self.view.bounds.width
        let pageHeight = self.view.bounds.height
        
        tabView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: tabHeight)
        tabView.backgroundColor = UIColor.white
        self.view.addSubview(tabView)
        let allButton = UIButton()
        let subButton = UIButton()
        tabView.addSubview(allButton)
        tabView.addSubview(subButton)
        allButton.setTitle("学院广场", for: .normal)
        allButton.setTitleColor(UIColor.black, for: .normal)
        subButton.setTitle("我的关注", for: .normal)
        subButton.setTitleColor(UIColor.black, for: .normal)
        allButton.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(self.view.bounds.width/2)
            $0.height.equalTo(50)
        })
        subButton.snp.makeConstraints({
             $0.bottom.equalToSuperview()
             $0.right.equalToSuperview()
             $0.width.equalTo(self.view.bounds.width/2)
             $0.height.equalTo(50)
         })
        
        var m = 0
        self.view.addSubview(scrollView)
        scrollView.frame = self.view.frame
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(vc.count), height: pageHeight-tabHeight)
        for i in vc{
            i.view.frame = CGRect(x: pageWidth * CGFloat(m),y: 0, width: pageWidth, height: pageHeight-tabHeight)
            self.scrollView.addSubview(i.view)
            self.addChild(i)
            m += 1
        }
        
    }
    
}


