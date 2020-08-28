//
//  UserInfo.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/28.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfo {
    var userId:Int?
    var avatar:String?
    var studentName:String?
    var hasSubscribed: Bool?
    var hasCheckd:Bool?
    
    init(_ json:JSON) {
        userId = json["userId"].int
        avatar = json["avatar"].string
        studentName = json["studentName"].string
        hasSubscribed = json["hasSubscribed"].bool
        hasCheckd = json["hasChecked"].bool
    }
}
