//
//  UIViewExtension.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/22.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    func addButtonLine() {
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
    
    func firstViewController() -> UIViewController? {
        print("寻找vc")
            for view in sequence(first: self.superview, next: { $0?.superview }) {
                if let responder = view?.next {
                    if responder.isKind(of: UIViewController.self){
                        print("找到\(responder)")
                        return responder as? UIViewController
                    }
                }
            }
            return nil
        }

}
