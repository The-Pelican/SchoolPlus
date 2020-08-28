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
    var vc : [MessagesViewController] = [MessagesViewController(),MessagesViewController()]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
    }

    func initSubView() {
        let pageWidth = self.view.frame.width
        let pageHeight = self.view.frame.height
        var m = 0
        scrollView.frame = self.view.frame
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(vc.count), height: pageHeight)
        for i in vc{
            i.view.frame = CGRect(x: pageWidth * CGFloat(m),y: 0, width: pageWidth, height: pageHeight)
            self.scrollView.addSubview(i.view)
            self.addChild(i)
            m += 1
        }
        self.view.addSubview(scrollView)
    }
    
}


