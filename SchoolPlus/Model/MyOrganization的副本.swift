//
//  MyOrganization.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/30.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyOrganization {
    var myIdentity:String?
    var organizationInfo:Organization?
    
    init() {
        
    }
    
    init(_ json:JSON){
        myIdentity = json["identity"].string
        organizationInfo = Organization(json["organization"])
    }
}
