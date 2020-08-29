//
//  DateExtension.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation

func timeIntervalToString(timeInterval:Double,dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
    let timestampDoubleInSec:Double = timeInterval / 1000
    let date:NSDate = NSDate.init(timeIntervalSince1970: timestampDoubleInSec)
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date as Date)
}

func getStringDate(date:[Int]) -> String {
    var strDate = ""
    let year = String(date[0])
    let month = String(date[1]) + "-"
    let day = String(date[2]) + " "
    let hour = String(date[3])+":"
    let min = String(date[4])
    strDate = year + month + day + hour + min
    return strDate
}

