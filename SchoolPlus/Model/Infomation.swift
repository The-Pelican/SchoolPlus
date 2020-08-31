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
    var newsId:Int?
    var publisher:UserInfo?
    var orgnization: Organization?
    var text:String?
    var media: [String]?
    var publishTime:String?
    var hasCheck:Bool?
    var likesNum:Int?
    var hasLiked:Bool?
    var commentsNum:Int?
    
    init() {
        
    }
    
    init (_ json:JSON) {
        newsId = json["newsId"].int
        publisher = UserInfo(json["publisher"])
        orgnization = Organization(json["organization"])
        text = json["text"].string
        hasCheck = json["hasCheck"].bool
        likesNum = json["likesNum"].int
        hasLiked = json["hasLiked"].bool
        commentsNum = json["commentsNum"].int
        
        if let medias = json["media"].string {
            let arr = getArrayFromJSONString(jsonString: medias)
            media = arr as? [String]
        }
        
        if let dateArr = json["publishTime"].array {
            var dateIntArr = [Int]()
            for n in dateArr {
                if let datePart = n.int {
                    dateIntArr.append(datePart)
                }
            }
            publishTime = getStringDate(date: dateIntArr)
        }
    }
    
    
    func likeNews(id:Int)  -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["newsId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .post, parameters: para, headers: headers).response(completionHandler: {
                (response) in
                debugPrint(response)
                if let statusCode = response.response?.statusCode {
                    if statusCode == 2385 {
                        user.outDated()
                        observer.onNext("请重新再试")
                    }
                }
                
                if let error = response.error {
                    observer.onError(error)
                }
                
                observer.onNext("success")
  
            })
            return Disposables.create()
        }
    }
    
    func dislikeNews(id:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["newsId":id]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
             AF.request(url, method: .delete, parameters: para, headers: headers).response(completionHandler: {
                           (response) in
                           debugPrint(response)
                if let statusCode = response.response?.statusCode {
                    if statusCode == 2385 {
                        user.outDated()
                        observer.onNext("请重新再试")
                    }
                }
                if let error = response.error {
                    observer.onError(error)
                }
                observer.onNext("success")
             })
            return Disposables.create()
        }
    }
    
    func editNews(newsId:Int, text:String, media:[String],pic: [UIImage])  -> Observable<String> {
     let url = URL(string: "http://www.chenzhimeng.top/fu-community/news")!
     let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let strId = String(newsId)
        let dataId = strId.data(using: .utf8)
        let dataText = text.data(using: .utf8)
        let mediaStr = media.description
        let mediaData = mediaStr.data(using: .utf8)
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
            multipartFormData.append(mediaData!, withName: "media")
             multipartFormData.append(dataText!, withName: "text")
             if !jpegData.isEmpty {
                 for data in jpegData {
                      multipartFormData.append(data, withName: "files", fileName: "files"+".jpeg", mimeType: "image/jpeg")
                  }
             }
         }, to: url, method: .put, headers: headers).responseJSON { (response) in
            debugPrint(response)
             switch response.result {
             case .success(let value):
                 print(value)
                 let json = JSON(value)
                 if let result = json.bool {
                     if result {
                         observer.onNext("success")
                     } else {
                         if let msg = json["msg"].string {
                             observer.onNext(msg)
                             return
                         }
                     }
                 }
             case .failure(let error):
                 print(error)
                 if let statusCode = response.response?.statusCode {
                     if statusCode == 2385 {
                         user.outDated()
                         observer.onNext("请重新再试")
                     }
                 }
                 observer.onError(error)
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
            AF.request(url, method: .delete, parameters: para, headers: headers).response(completionHandler: {
                          (response) in
                          debugPrint(response)
                if let statusCode = response.response?.statusCode {
                    if statusCode == 2385 {
                        user.outDated()
                        observer.onNext("请重新再试")
                    }
                }
                          if let error = response.error {
                              observer.onError(error)
                          }
                          observer.onNext("success")
            })
            return Disposables.create()
        }
    }
}
