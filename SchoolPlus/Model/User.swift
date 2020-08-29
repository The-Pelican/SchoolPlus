//
//  User.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/9.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire
import SwiftyJSON
import ProgressHUD
import CryptoSwift
import RxSwift

var user = User()

enum LoginType {
    case none
    
    case logined
    
    case loginFailed
}

class User: NSObject {
    var pho = ""
    var pwd = ""
    var accessToken = ""
    var refreshToken = ""
    var userId = -1
    var hasChecked:Bool?
    var avatar = "未设置"
    var name = "无名"
    
    var loginType = LoginType.none
    let disposeBag = DisposeBag()
    
    override init() {
        let keychain = KeychainSwift()
        
        if let i = keychain.get("pho") { pho = i } else {pho = ""}
        if let p = keychain.get("password") { pwd = p} else { pwd = ""}
        if let aT = keychain.get("accessToken") {accessToken = aT} else {accessToken = ""}
        if let rT = keychain.get("refreshToken") {refreshToken = rT} else {refreshToken = ""}
    }
    
    init(pho: String, pwd:String) {
        self.pho = pho
        self.pwd = pwd
        
        //let ud = UserDefaults.standard
        let keychain = KeychainSwift()
        if let aT = keychain.get("accessToken") {accessToken = aT} else {accessToken = ""}
        if let rT = keychain.get("refreshToken") {refreshToken = rT} else {refreshToken = ""}
    }
    
    init(pho: String) {
        self.pho = pho
        
        //let ud = UserDefaults.standard
        let keychain = KeychainSwift()
        if let p = keychain.get("password") { pwd = p} else { pwd = ""}
        if let aT = keychain.get("accessToken") {accessToken = aT} else {accessToken = ""}
        if let rT = keychain.get("refreshToken") {refreshToken = rT} else {refreshToken = ""}
    }
    
    func save() {
        let keychain = KeychainSwift()
        
        keychain.set(pho, forKey: "pho")
        keychain.set(pwd, forKey: "password")
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    func saveInfo() {
        var state = 0
        switch hasChecked {
        case true:
            state = 1
        case false:
            state = 0
        case nil:
            state = -1
        default:
            state = 0
        }
        
        let keychain = KeychainSwift()
        keychain.set("\(userId)", forKey: "userId")
        keychain.set(avatar, forKey: "avatar")
        keychain.set(name, forKey: "studentName")
        keychain.set("\(state)", forKey: "hasChecked")
    }
    
    func logout() {
        pho = ""
        pwd = ""
        accessToken = ""
        refreshToken = ""
        userId = -1
        avatar = "未设置"
        name = "无名"
        user.save()
        user.saveInfo()
    }
    
    //MARK:-注册登录
    
    
    func regiAuthCode(id:String) {
        AF.request("http://www.chenzhimeng.top/fu-community/user/auth/register", method: .post, parameters: ["phoneNo":id]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                if let result = json["result"].int {
                    if result == 1 {
                        if let k = json["key"].string { key = k}
                    } else {
                        if let m = json["msg"].string { ProgressHUD.showFailed(m) }
                    }
                }
            case .failure(let error):
                print(error)
                ProgressHUD.showError(SchoolError.afError.localizedDescription)
            }
        }
    }
    
    func loginAuthCode(pho:String) {
        AF.request("http://www.chenzhimeng.top/fu-community/user/auth/login", method: .post, parameters: ["phoneNo":pho]).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let result = json["result"].bool {
                    if result {
                        if let k = json["key"].string { key = k }
                    } else { if let m = json["msg"].string { ProgressHUD.showFailed(m) } }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func register(pho:String,pwd:String,key:String,code:Int) -> Observable<String> {
        let digest = pwd.md5()
        let para = ["phoneNo":pho,"password":digest,"key":key,"authCode":code] as [String : Any]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request("http://www.chenzhimeng.top/fu-community/user", method: .post, parameters: para).responseJSON { (response) in
                switch response.result {
                 case .success(let value):
                     let json = JSON(value)
                     print(value)
                     if let result = json["result"].bool {
                         if result {
                            if let aT = json["tokens"][0].string, let rT = json["tokens"][1].string {
                                user.accessToken = aT
                                user.refreshToken = rT
                                user.pho = pho
                                user.pwd = pwd
                                observer.onNext("success")
                            }
                         } else {
                            if let m = json["msg"].string {
                                observer.onError(SchoolError.loginFail(m))
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
    
    
    func codeLogin(pho:String,key:String,code: Int) -> Observable<String> {
        let para = ["key":key,"authCode": code] as [String:Any]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request("http://www.chenzhimeng.top/fu-community/user/login/auth-code/\(pho)", method: .post, parameters: para).responseJSON{
                (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let result = json["result"].bool else {
                        observer.onError(SchoolError.unexpected)
                        return
                    }
                    if result {
                        if let aT = json["tokens"][0].string,let rT = json["tokens"][1].string {
                            user.accessToken = aT
                            user.refreshToken = rT
                            observer.onNext("finished")
                            return
                        }
                        if json["msg"].string != nil {
                            user.pho = pho
                            observer.onNext("unfinished")
                            return
                        }
                        observer.onError(SchoolError.unexpected)
                    } else {
                        guard let msg = json["msg"].string else {
                            observer.onError(SchoolError.unexpected)
                            return
                        }
                        observer.onError(SchoolError.authFail(msg))
                    }
                    
                case .failure(let error):
                    print(error)
                    observer.onError(SchoolError.afError)
                }
            }
            return Disposables.create()
        }
    }
    
    func pwdLogin(pho:String,pwd:String) -> Observable<String> {
        print("密码登录")
        let digest = pwd.md5()
        let para = ["password":digest]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request("http://www.chenzhimeng.top/fu-community/user/login/password/\(pho)", method: .post, parameters: para).responseJSON {
                (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(value)
                    if let result = json["result"].bool {
                        if result {
                            if let aT = json["tokens"][0].string, let rT = json["tokens"][1].string {
                                user.pho = pho
                                user.pwd = pwd
                                user.accessToken = aT
                                user.refreshToken = rT
                                observer.onNext("success")
                                return
                            }
                            observer.onError(SchoolError.unexpected)
                            return
                        } else {
                            if let m = json["msg"].string {
                                observer.onNext(m)
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
    
    
    func refreshPW(pho:String, key:String, code:Int, pwd:String) {
        let digest = pwd.md5()
        let para = ["key":key, "authCode":code,"password":digest] as [String:Any]
        print(para)
        print("http://www.chenzhimeng.top:10001/user/password/\(pho)")
        AF.request("http://www.chenzhimeng.top/fu-community/user/password/\(pho)", method: .put, parameters: ["key":key, "authCode":code,"password":digest]).responseJSON {
            (response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                let json  = JSON(value)
                if let result = json["result"].bool {
                    if result {
                        user.pho = pho
                        user.pwd = pwd
                        user.save()
                        ProgressHUD.showSucceed()
                    } else {
                        if let m = json["msg"].string {
                            ProgressHUD.showError(m)
                        }
                    }
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func uploadAM(name:String,num:String,card:UIImage) -> Observable<String>{
        let studentName = name.data(using: String.Encoding.utf8)
        let studentNo = num.data(using: String.Encoding.utf8)
        let cardData = card.jpegData(compressionQuality: 0.1)
        let para = ["studentName":studentName!, "studentNo":studentNo!,"card":cardData!] as [String:Any]
        print(name)
        print(num)
        print(cardData!)
        let headers: HTTPHeaders
            headers = [
            "accessToken":user.accessToken,"Content-type":"multipart/form-data","Content-Disposition":"form-data"
        ]
        print(headers)
        return Observable<String>.create { (observer) -> Disposable in
            AF.upload(multipartFormData: { (multiPart) in
                 multiPart.append(studentNo!, withName: "studentNo")
                 multiPart.append(studentName!, withName: "studentName")
                 multiPart.append(cardData!, withName: "card", fileName:  "card.jpeg", mimeType: "image/jpeg")
                }, to: "http://www.chenzhimeng.top/fu-community/user/identity", usingThreshold:UInt64.init(), method: .put, headers:headers).responseJSON { (response) in
                    debugPrint(response)
                    switch response.result {
                    case .success(let value):
                        print(value)
                        observer.onNext("success")
                    case.failure(let error):
                        print(error)
                        observer.onError(error)
                    }
             }
 
            return Disposables.create()
        }
    }
    
    
    
//    MARK:-获取token
    func updateToken(aT:String,rT:String) {
        let para = ["accessToken":user.accessToken,"refreshToken":user.refreshToken]
        AF.request("http://www.chenzhimeng.top/fu-community/user/token", method: .put, parameters: para).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let aT = json["accessToken"].string, let rT = json["refreshToken"].string {
                    user.accessToken = aT
                    user.refreshToken = rT
                    user.save()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
//    MARK:- 获取个人信息
    //自动登录
        func getMyMessage() -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/-1")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url,method: .get,headers: headers).responseJSON(completionHandler: {
                (response) in
                switch response.result  {
                case .success(let value):
                    let json = JSON(value)
                    user.userId = json["userId"].int ?? -1
                    user.hasChecked = json["hasCheck"].bool
                    user.name = json["studentName"].string ?? "未设置"
                    user.saveInfo()
                    observer.onNext("success")
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
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
                    print(error)
                }
            })
            return Disposables.create()
        }
    }
    
    
    func getSuscribedUsers() {
        
    }
    
    func getSubscribedGroups() {
        
    }
    
    func changeAvatar() {
        
    }
    
    func getMessageList() {
        
    }
    
    

//    MARK:-动态操作
    func subscribeUser(userId:Int) -> Observable<String>{
        let para = ["userId":userId]
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/fans")!
        
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url,method: .post,parameters: para,headers: headers).response {
                (response) in
                debugPrint(response)
                if let error = response.error {
                    observer.onError(error)
                }
                observer.onNext("success")
            }
            return Disposables.create()
        }
    }
    
    func subscribeOragnization(organizationId:Int) -> Observable<String>{
        let para = ["organizationId":organizationId]

                
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/fans")!
        
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url,method: .post,parameters: para,headers: headers).response {
                (response) in
                debugPrint(response)
                if let error = response.error {
                    observer.onError(error)
                }
                observer.onNext("success")
            }
            return Disposables.create()
        }
    }
    
    
    
    func cancelSubscribe(userId:Int?,organizationId:Int?) -> Observable<String>{
        var para = ["organization":organizationId]
        
        if let userId = userId {
            para = ["userId":userId]
        }
        
        if let organizationId = organizationId  {
            para = ["organization":organizationId]
        }
        
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/fans")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url,method: .delete,parameters: para,headers: headers).response {
                (response) in
                debugPrint(response)
                if let error = response.error {
                    observer.onError(error)
                }
                observer.onNext("success")
            }
            return Disposables.create()
        }
    }
    
    func uploadNews(text:String?,pic:[UIImage]) -> Observable<String>{
        let text = text ?? ""
        let textData = text.data(using: .utf8)!
        var jpegData = [Data]()
        for image in pic {
            let imageData = image.jpegData(compressionQuality: 0.2)
            if let data = imageData {
                jpegData.append(data)
            }
        }
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        return Observable<String>.create { (observer) -> Disposable in
            AF.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(textData, withName: "text")
                if !jpegData.isEmpty {
                    for data in jpegData {
                         multipartFormData.append(data, withName: "files", fileName: "files"+".jpeg", mimeType: "image/jpeg")
                     }
                }
            }, to: "http://www.chenzhimeng.top/fu-community/news", method: .post,headers: headers).responseJSON { (response) in
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
    
    
    func likeComment(commentId:Int) -> Observable<String>{
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["commentId":commentId]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]

        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .post, parameters: para, headers: headers).response(completionHandler: {
                          (response) in
                          debugPrint(response)
                          if let error = response.error {
                              observer.onError(error)
                          }
                          observer.onNext("success")
            })
            return Disposables.create()
        }
    }
    
    func dislikeComment(commentId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/like")!
        let para = ["commentId":commentId]
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]

        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .delete, parameters: para, headers: headers).response(completionHandler: {
                          (response) in
                          debugPrint(response)
                          if let error = response.error {
                              observer.onError(error)
                          }
                          observer.onNext("success")
            })
            return Disposables.create()
        }
    }
    
}
