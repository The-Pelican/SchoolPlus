//
//  InfomationViewModel.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/13.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift

class InformationViewModel {
    var message:[Infomation] = []
    var comment:[Comment] = []
    let length = 5
    var pageNum = 0
    let disposeBag = DisposeBag()
    
 
    
    func getData() -> Observable<String> {
        print(pageNum)
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/\(pageNum)/\(length)")
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url!,method:.get,headers: headers).responseJSON(completionHandler: {
                [weak self](response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(value)
                    if let newsJSON = json.array {
                        for news in newsJSON {
                            //判断组织还是个人动态
                            if let userId = news["publisher"]["userId"].int {
                                if let name = news["publisher"]["studentName"].string,let avartar = news["publisher"]["avatar"].string, let dateJSON = news["publishTime"].array, let content = news["text"].string, let hasLiked = news["hasLiked"].bool, let likes = news["likesNum"].int, let commentCount = news["commentsNum"].int,let newsId = news["newsId"].int,let hasSubscribe = news["publisher"]["hasSubscribed"].bool {
                                    
                                    var date = ""
                                    for n in dateJSON {
                                        if let datePart = n.int {
                                            date += "\(datePart)"
                                        }
                                    }
                                    
                                    var media = [String]()
                                    if let audioJSON = news["media"].string {
                                         let arr = getArrayFromJSONString(jsonString: audioJSON)
                                         if arr != nil {
                                             media = arr as! [String]
                                         }
                                    }
                                    
        
                                    let info = Infomation(sender: name, date: date, content: content, audioPath: media, comment: commentCount, like: likes, hasLiked: hasLiked, hasSubscribe: hasSubscribe, avartar: avartar, userId: userId, organizationId: -1,newsId: newsId)
                                    
                                    self?.message.append(info)
                                }
                            }
                            
                            if let organizationId = news["organization"]["organizationId"].int {
                                print("组织动态")
                                if let name = news["organization"]["organizationName"].string,let avartar = news["organization"]["logo"].string, let dateJSON = news["publishTime"].array, let content = news["text"].string, let hasLiked = news["hasLiked"].bool, let likes = news["likesNum"].int, let commentCount = news["commentsNum"].int,let newsId = news["newsId"].int,let hasSubscribe = news["organization"]["hasSubscribed"].bool {
                                    print("获取\(name)")
                                    
                                    var media = [String]()
                                    if let audioJSON = news["media"].string {
                                        let arr = getArrayFromJSONString(jsonString: audioJSON)
                                        print(arr)
                                        if arr != nil {
                                            media = arr as! [String]
                                        }
                                    }
                                    
                                    var date = ""
                                    for n in dateJSON {
                                        if let datePart = n.string {
                                            date += datePart
                                        }
                                    }
                                    
                                    let info = Infomation(sender: name, date: date, content: content, audioPath: media, comment: commentCount, like: likes, hasLiked: hasLiked, hasSubscribe: hasSubscribe, avartar: avartar, userId: -1, organizationId: organizationId,newsId: newsId)
                                    
                                    self?.message.append(info)
                                }
                            }
                        }
                        
                        for i in self!.message {
                            print(i.avartar)
                            print(i.audioPath)
                        }
                        observer.onNext("success")
                    }
                    
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func gesubScribeData() -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/subscribed/\(pageNum)/\(length)")
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        print(user.accessToken)
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url!,method:.get,headers: headers).responseJSON(completionHandler: {
                [weak self](response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    if let newsJSON = json.array {
                        for news in newsJSON {
                            //判断组织还是个人动态
                            if let userId = news["publisher"]["userId"].int {
                                if let name = news["publisher"]["studentName"].string,let avartar = news["publisher"]["avatar"].string, let dateJSON = news["publishTime"].array, let content = news["text"].string, let hasLiked = news["hasLiked"].bool, let likes = news["likesNum"].int, let commentCount = news["commentsNum"].int,let newsId = news["newsId"].int,let hasSubscribe = news["publisher"]["hasSubscribed"].bool {
                                    
                                    var date = ""
                                    for n in dateJSON {
                                        if let datePart = n.int {
                                            date += "\(datePart)"
                                        }
                                    }
                                    
                                    var media = [String]()
                                    if let audioJSON = news["media"].string {
                                         let arr = getArrayFromJSONString(jsonString: audioJSON)
                                         print(arr)
                                         media = arr as! [String]
                                    }
                                    
        
                                    let info = Infomation(sender: name, date: date, content: content, audioPath: media, comment: commentCount, like: likes, hasLiked: hasLiked, hasSubscribe: hasSubscribe, avartar: avartar, userId: userId, organizationId: -1,newsId: newsId)
                                    
                                    self?.message.append(info)
                                }
                            }
                            
                            if let organizationId = json["organization"]["organizationId"].int {
                                if let name = news["organization"]["organizationName"].string,let avartar = news["organization"]["logo"].string, let dateJSON = news["publishTime"].array, let content = news["text"].string, let hasLiked = news["hasLiked"].bool, let likes = news["likesNum"].int, let commentCount = news["commentsNum"].int,let newsId = news["newsId"].int,let hasSubscribe = news["organization"]["hasSubscribed"].bool {
                                    print("获取\(name)")
                                    
                                    var media = [String]()
                                    if let audioJSON = news["media"].string {
                                        let arr = getArrayFromJSONString(jsonString: audioJSON)
                                        print(arr)
                                        media = arr as! [String]
                                    }
                                    
                                    var date = ""
                                    for n in dateJSON {
                                        if let datePart = n.string {
                                            date += (datePart+"-")
                                
                                        }
                                    }
                                    
                                    let info = Infomation(sender: name, date: date, content: content, audioPath: media, comment: commentCount, like: likes, hasLiked: hasLiked, hasSubscribe: hasSubscribe, avartar: avartar, userId: -1, organizationId: organizationId,newsId: newsId)
                                    
                                    self?.message.append(info)
                                }
                            }
                        }
                        
                        for i in self!.message {
                            print(i.avartar)
                            print(i.audioPath)
                        }
                        observer.onNext("success")
                    }
                    
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    
        
    }
    
    
    
    /*func likeNews(id:Int) {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["newId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]

        AF.request(url, method: .post, parameters: para, headers: headers).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success( _):
                print("success")
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func unlikeNews(id:Int) {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["newId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]

        AF.request(url, method: .delete, parameters: para, headers: headers).responseJSON(completionHandler: {
            (response) in
            switch response.result {
            case .success( _):
                print("success")
            case .failure(let error):
                print(error)
            }
        })
    }*/
    
    func getNewsComments(id:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/comment/\(pageNum)/\(length)")!
        let para = ["newsId":id,"orderBy":"likesNum"] as [String : Any]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .get, parameters: para, headers: headers).responseJSON(completionHandler: {
                (response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    if let commentJSON = json.array {
                        for comment in commentJSON {
                            if let userId = comment["user"]["userId"].int,let name = comment["user"]["studentName"].string,let avartar = comment["user"]["avatar"].string, let dateInt = comment["commentTime"].int,let newsId = comment["newsId"].int,let content = comment["text"].string, let hasLiked = comment["hasLiked"].bool, let likes = comment["likesNum"].int ,let commentId = comment["commentId"].int{
                                let info = Comment(sender: name, date: "\(dateInt)", content: content, audioPath: "", like: likes, hasLiked: hasLiked, avartar: avartar, userId: userId, newsId:newsId , commentId: commentId)
                                print(name)
                                self.comment.append(info)
                            }
                        }
                        observer.onNext("success")
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func getReplyComments(id:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/comment/\(pageNum)/\(length)")!
        let para = ["replyId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .get, parameters: para, headers: headers).responseJSON(completionHandler: {
                (response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(value)
                    if let commentJSON = json.array {
                        for comment in commentJSON {
                            if let userId = comment["user"]["userId"].int,let name = comment["user"]["studentName"].string,let avartar = comment["user"]["avatar"].string, let dateInt = comment["commentTime"].int, let content = comment["text"].string, let hasLiked = comment["hasLiked"].bool,let newsId = comment["newsId"].int,let likes = comment["likesNum"].int, let commentId = comment["commentId"].int{
                                
                                let info = Comment(sender: name, date: "\(dateInt)", content: content, audioPath: "", like: likes, hasLiked: hasLiked, avartar: avartar, userId: userId, newsId:newsId , commentId: commentId)
                                self.comment.append(info)
                                
                            }
                        }
                        observer.onNext("success")
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func giveComment(newsId:Int, text:String, pic: UIImage?)  -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/comment")!
        let headers: HTTPHeaders = [
               "accessToken": user.accessToken
           ]
        let strId = String(newsId)
        let dataId = strId.data(using: .utf8)
        let dataText = text.data(using: .utf8)
        let picData = pic?.jpegData(compressionQuality: 0.5)
        
        
           
           return Observable<String>.create { (observer) -> Disposable in
            
            AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(dataId!, withName: "newsId")
                multipartFormData.append(dataText!, withName: "text")
                if let picData = picData {
                    multipartFormData.append(picData, withName: "picFile", fileName: "picFile"+".jpeg", mimeType: "image/jpeg")
                }
            }, to: url, method: .post, headers: headers).responseJSON { (response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    if let result = json["result"].bool {
                        if result {
                            observer.onNext("success")
                            return
                        } else {
                            if let msg = json["msg"].string {
                                
                                observer.onError(SchoolError.authFail(msg))
                                return
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(SchoolError.afError)
                }
            }
               return Disposables.create()
           }
       }
    
    func deleteComment(commentId:Int) -> Observable<String>{
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/comment")!
        let para = ["commentId":commentId]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url,method: .delete,parameters: para,headers: headers).responseJSON(completionHandler: { (response) in
                debugPrint(response)
                switch response.result {
                case .success( _):
                    print("success")
                    observer.onNext("success")
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
