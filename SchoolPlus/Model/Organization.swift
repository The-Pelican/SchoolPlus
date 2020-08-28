//
//  Organization.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/18.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON

class Organization {
    var organizationId:Int?
    var organizationName:String?
    var slogan:String?
    var intro:String?
    var auditor:String?
    var hasSubscribed:Bool?
    
    init() {
        
    }
    
    init(_ json:JSON){
        organizationId = json["organizationId"].int
        organizationName = json["organizationName"].string
        slogan = json["slogan"].string
        intro = json["intro"].string
        auditor = json["auditor"].string
        hasSubscribed = json["hasSubscribed"].bool
    }
}
