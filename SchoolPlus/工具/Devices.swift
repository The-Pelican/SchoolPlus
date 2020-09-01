//
//  Devices.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/22.
//  Copyright © 2020 金含霖. All rights reserved.
//

import UIKit

var navigationBarHeight = UINavigationController().navigationBar.frame.height

var tabBarHeight = UITabBarController().tabBar.frame.height

var safeAreaTopHeight: CGFloat {
    if #available(iOS 11.0, *) {
        return (UIApplication.shared.delegate?.window?!.safeAreaInsets.top)!
    }
    else{
        return UIApplication.shared.statusBarFrame.size.height
    }
}
