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
    var logo:String?
    var slogan:String?
    var intro:String?
    var founderId:Int?
    var founder:String?
    var auditor:String?
    var hasCheck:Bool?
    var hasSubscribed:Bool?
    
    init() {
        
    }
    
    init(_ json:JSON){
        organizationId = json["organizationId"].int
        organizationName = json["organizationName"].string
        logo = json["logo"].string
        slogan = json["slogan"].string
        intro = json["intro"].string
        founder = json["founder"].string
        founderId = json["founderId"].int
        auditor = json["auditor"].string
        hasCheck = json["hasCheck"].bool
        hasSubscribed = json["hasSubscribed"].bool
    }
}
