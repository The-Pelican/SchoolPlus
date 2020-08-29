//
//  Notice.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON

class Notice {
    var messageId:Int?
    var receiverId:Int?
    var type:Int?
    var content:String?
    var time:Int?
    var hasRead:Bool?
    
    init(_ json:JSON) {
        messageId = json["messageId"].intValue
        receiverId = json["receiverId"].intValue
        type = json["type"].intValue
        time = json["time"].intValue
        content = json["content"].stringValue
        hasRead = json["hasRead"].boolValue
        
    }
    
}
