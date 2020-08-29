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
                    if let newsJson = json.array {
                        for news in newsJson {
                            let info = Infomation(news)
                            self?.message.append(info)
                        }
                        observer.onNext("success")
                    }
                    
                case .failure(let error):
                    print(error)
                    if let statusCode = response.response?.statusCode {
                        print(statusCode)
                        switch statusCode {
                        case 2387:
                            observer.onNext("功能未解锁")
                        case 2385:
                            observer.onNext("token过期")
                        case 2386:
                            observer.onNext("账号异地登陆")
                        default:
                            break
                        }
                    }
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func getSubscribeData() -> Observable<String> {
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
                    let json = JSON(value)
                    print(value)
                    if let newsJson = json.array {
                        for news in newsJson {
                            let info = Infomation(news)
                            self?.message.append(info)
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
                            let com = Comment(comment)
                            self.comment.append(com)
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
                            let com = Comment(comment)
                            self.comment.append(com)
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
                                observer.onNext(msg)
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
