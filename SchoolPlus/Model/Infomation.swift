//
//  Infomation.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/20.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

class Infomation {
    var sender = ""
    var date = ""
    var content = ""
    var avartar = ""
    var audioPath = [String]()
    var comment = 5
    var like = 0
    var userId = -1
    var organizationId = -1
    var newsId = -1
    var hasLiked = false
    var hasSubscribe = false
    
    let disposeBag = DisposeBag()
    
    init() {
        sender = ""
        date = ""
        content = ""
        avartar = ""
        audioPath = [String]()
        comment = 5
        like = 0
        userId = -1
        organizationId = -1
        newsId = -1
        hasLiked = false
        hasSubscribe = false
    }
    
    init(sender:String,date:String,content:String,audioPath:[String],comment:Int,like:Int,hasLiked:Bool,hasSubscribe:Bool,avartar:String, userId:Int,organizationId:Int,newsId:Int) {
        self.sender = sender
        self.date = date
        self.content = content
        self.audioPath = audioPath
        self.comment = comment
        self.like = like
        self.hasLiked = hasLiked
        self.hasSubscribe = hasSubscribe
        self.avartar = avartar
        self.userId = userId
        self.organizationId = organizationId
        self.newsId = newsId
    }
    
    func likeNews(id:Int)  -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["newId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .post, parameters: para, headers: headers).responseJSON(completionHandler: {
                (response) in
                switch response.result {
                case .success( _):
                    print("success")
                case .failure(let error):
                    print(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func dislikeNews(id:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["newId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .delete, parameters: para, headers: headers).responseJSON(completionHandler: {
                (response) in
                switch response.result {
                case .success( _):
                    print("success")
                case .failure(let error):
                    print(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func editNews(newsId:Int, text:String, pic: [UIImage])  -> Observable<String> {
     let url = URL(string: "http://www.chenzhimeng.top/fu-community/news")!
     let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
     let strId = String(newsId)
     let dataId = strId.data(using: .utf8)
     let dataText = text.data(using: .utf8)
     var jpegData = [Data]()
     for image in pic {
         let imageData = image.jpegData(compressionQuality: 0.5)
         if let data = imageData {
             jpegData.append(data)
         }
     }
        return Observable<String>.create { (observer) -> Disposable in
         
         AF.upload(multipartFormData: { (multipartFormData) in
             multipartFormData.append(dataId!, withName: "newsId")
             multipartFormData.append(dataText!, withName: "text")
             if !jpegData.isEmpty {
                 for data in jpegData {
                      multipartFormData.append(data, withName: "files", fileName: "files"+".jpeg", mimeType: "image/jpeg")
                  }
             }
         }, to: url, method: .post, headers: headers).responseJSON { (response) in
             switch response.result {
             case .success(let value):
                 print(value)
                 let json = JSON(value)
                 if let result = json.bool {
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
    
    func deleteNews(newsId:Int) -> Observable<String>{
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news")!
        let para = ["newsId":newsId]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url,method: .delete,parameters:para,headers: headers).responseJSON(completionHandler: { (response) in
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
