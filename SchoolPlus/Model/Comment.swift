//
//  Comment.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/27.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment {
    var commentId:Int?
    var userId: Int?
    var userInfo: UserInfo?
    var newsId:Int?
    var replyId:Int?
    var text:String?
    var pic:String?
    var commentTime:Int?
    var hasLiked:Bool?
    var likesNum:Int?
    var commentsNum:Int?
    
    init() {
        
    }
    
    
    init(_ json:JSON) {
        commentId = json["commentId"].int
        userId = json["userId"].int
        userInfo = UserInfo(json["user"])
        newsId = json["newsId"].int
        replyId = json["replyId"].int
        text = json["text"].string
        pic = json["pic"].string
        commentTime = json["commentTime"].int
        hasLiked = json["hasLiked"].bool
        likesNum = json["likesNum"].int
        commentsNum = json["commentsNum"].int
        
    }
}
