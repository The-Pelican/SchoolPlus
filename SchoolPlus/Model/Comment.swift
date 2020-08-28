//
//  Comment.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/27.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation

class Comment {
    var sender = ""
    var date = ""
    var content = ""
    var avartar = ""
    var audioPath = ""
    //var comment = 5
    var like = 0
    var userId = -1
    var commentId = -1
    var newsId = -1
    var hasLiked = false
    
    init() {
        
    }
    
    init(sender:String,date:String,content:String,audioPath:String,like:Int,hasLiked:Bool,avartar:String, userId:Int,newsId:Int,commentId:Int) {
        self.sender = sender
        self.date = date
        self.content = content
        self.audioPath = audioPath
        self.like = like
        self.hasLiked = hasLiked
        self.avartar = avartar
        self.userId = userId
        self.newsId = newsId
        self.commentId = commentId
    }
}
