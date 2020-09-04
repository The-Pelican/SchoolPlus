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
    var timer:Timer?
    
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
                ProgressHUD.showError()
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
    
    func  rePWAuthCode(pho:String){
        AF.request("http://www.chenzhimeng.top/fu-community/user/auth/verify", method: .post, parameters: ["phoneNo":pho]).responseJSON { (response) in
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
                       ProgressHUD.showError()
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
                                observer.onNext(m)
                            }
                        }
                     }
                 case .failure(let error):
                    print(error)
                    observer.onError(error)
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
                        observer.onNext("未知")
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
                    } else {
                        guard let msg = json["msg"].string else {
                            observer.onNext("未知")
                            return
                        }
                        observer.onNext(msg)
                    }
                    
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func pwdLogin(pho:String,pwd:String) -> Observable<String> {
        print("密码登录")
        let digest = pwd.md5()
        print(digest)
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
                            observer.onNext("未知")
                            return
                        } else {
                            if let m = json["msg"].string {
                                ProgressHUD.showFailed(m)
                                observer.onNext(m)
                                return
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
    func refreshPW(pho:String, key:String, code:Int, pwd:String) {
        let digest = pwd.md5()
        let para = ["key":key, "authCode":code,"password":digest] as [String:Any]
        print(para)
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
                        let json = JSON(value)
                        if let result = json["result"].bool {
                            if result {
                                observer.onNext("success")
                            } else {
                                if let m = json["msg"].string {
                                    observer.onNext(m)
                                }
                            }
                        }
                        
                    case.failure(let error):
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
    
    
    
//    MARK:-获取token
    func updateToken(aT:String,rT:String)  -> Observable<String>{
        let para = ["accessToken":user.accessToken,"refreshToken":user.refreshToken]
         return Observable<String>.create { (observer) -> Disposable in
        AF.request("http://www.chenzhimeng.top/fu-community/user/token", method: .put, parameters: para).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let aT = json["accessToken"].string, let rT = json["refreshToken"].string {
                    user.accessToken = aT
                    user.refreshToken = rT
                    user.save()
                    observer.onNext("success")
                }
                observer.onNext("fail")
            case.failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
        }
    }
    
    func outDated() {
            user.updateToken(aT: user.accessToken, rT: user.refreshToken).subscribe(onNext:{ string in
                 if string == "fail" {
                    ProgressHUD.showFailed("token过期，请重新登录")
                     user.logout()
                     let navigationController = UINavigationController(rootViewController: LoginViewController())
                     Navigator.window().rootViewController = navigationController
                 } else {
                    ProgressHUD.showSucceed("请刷新再试")
                }
             },onError: { error in
                 user.logout()
                 let navigationController = UINavigationController(rootViewController: LoginViewController())
                 Navigator.window().rootViewController = navigationController
            }).disposed(by: self.disposeBag)
    }
    
    
//    MARK:- 定时检查用户情况
    
//    MARK:- 个人信息
    //自动登录
        func getMyMessage() -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/-1")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        
        return Observable<String>.create { (observer) -> Disposable in
            let request = AF.request(url,method: .get,headers: headers)
            AF.request(url,method: .get,headers: headers).responseJSON(completionHandler: {
                (response) in
                switch response.result  {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    user.userId = json["userId"].int ?? -1
                    user.hasChecked = json["hasCheck"].bool
                    user.name = json["studentName"].string ?? ""
                    user.avatar = json["avatar"].string ?? ""
                    user.saveInfo()
                    observer.onNext("success")
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
            })
            return Disposables.create()
        }
    }
    
    

    
    func changeAvatar(image:UIImage)-> Observable<String> {
        let imageData = image.jpegData(compressionQuality: 0.1)
        let headers: HTTPHeaders
            headers = [
            "accessToken":user.accessToken,"Content-type":"multipart/form-data","Content-Disposition":"form-data"
        ]
        return Observable<String>.create { (observer) -> Disposable in
            AF.upload(multipartFormData: { (multiPart) in
                multiPart.append(imageData!, withName: "avatar", fileName:  "avatar.jpeg", mimeType: "image/jpeg")
                  }, to: "http://www.chenzhimeng.top/fu-community/user/avatar", usingThreshold:UInt64.init(), method: .put, headers:headers).responseJSON { (response) in
                      debugPrint(response)
                      switch response.result {
                      case .success(let value):
                          print(value)
                          observer.onNext("success")
                      case.failure(let error):
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
                if let statusCode = response.response?.statusCode {
                    if statusCode == 2385 {
                        user.outDated()
                        observer.onNext("请重新再试")
                    }
                } else if let error = response.error {
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
            }
            return Disposables.create()
        }
    }
    
    func uploadNews(text:String?,pic:[UIImage]) -> Observable<String>{
        let textData = text?.data(using: .utf8)!
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
        
        print(textData)
        print(jpegData)
        print(headers)
        return Observable<String>.create { (observer) -> Disposable in
            AF.upload(multipartFormData: { (multipartFormData) in
                if let textData = textData {
                    multipartFormData.append(textData, withName: "text")
                }
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
                            
                        } else {
                            if let msg = json["msg"].string {
                                
                                observer.onNext(msg)
                                
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
