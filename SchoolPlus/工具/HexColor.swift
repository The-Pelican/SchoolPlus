//
//  HexColor.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/10.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(valueStr:String) {
        let scanner:Scanner = Scanner(string:valueStr)
        var valueRGB:UInt64 = 0
        if scanner.scanHexInt64(&valueRGB) == false {
            self.init(red: 0,green: 0,blue: 0,alpha: 0)
        }else{
            self.init(
                red:CGFloat((valueRGB & 0xFF0000)>>16)/255.0,
                green:CGFloat((valueRGB & 0x00FF00)>>8)/255.0,
                blue:CGFloat(valueRGB & 0x0000FF)/255.0,
                alpha:CGFloat(1.0)
            )
        }
    }
}
