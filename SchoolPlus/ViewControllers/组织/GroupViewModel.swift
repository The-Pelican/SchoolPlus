//
//  GroupViewModel.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import ProgressHUD


class GroupViewModel {
    var groups = [Organization]()
    var recommendGroup = [Organization]()
    var searchGroup = [Organization]()
    var groupNews = [Infomation]()
    var memberList : [String:[UserInfo]] = [:]
    var applicationList = [UserInfo]()
    var oneGroup = MyOrganization()
    let disposeBag = DisposeBag()
    var pageNum = 0
    var length = 5
    
    //查找组织
    func searchGroups(text:String) -> Observable<String> {
        let headers:HTTPHeaders = ["accessToken":user.accessToken, "refreshToken":user.refreshToken]
        return Observable<String>.create { (observer) -> Disposable in
        AF.request("http://www.chenzhimeng.top/fu-community/organization/\(text)", method: .get, parameters: nil, headers: headers).responseJSON {
            (response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                if let groupsJson = json.array {
                    for groupJson in groupsJson {
                        let group = Organization(groupJson)
                        self.searchGroup.append(group)
                    }
                    observer.onNext("success")
                }
                observer.onNext("success")
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    //获得我关注的组织
    func getMyGroups() -> Observable<String> {
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        
        return Observable<String>.create { (observer) -> Disposable in
        
        AF.request("http://www.chenzhimeng.top/fu-community/organization/my", method: .get, headers: headers).responseJSON {
            (response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                if let groupsJson = json["my"].array {
                    for groupJson in groupsJson {
                        let group = Organization(groupJson)
                        self.groups.append(group)
                    }
                }
                if let reGroupsJson = json["recommend"].array {
                    for groupJson in reGroupsJson {
                        let group = Organization(groupJson)
                        self.recommendGroup.append(group)
                    }
                    observer.onNext("success")
                }
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    //创建组织
    func createGroup(name:String,logo:UIImage,slogan:String,intro:String,contact:String) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization")!
        let headers: HTTPHeaders = [
               "accessToken": user.accessToken
           ]
           let dataName = name.data(using: .utf8)
           let dataSlogan = slogan.data(using: .utf8)
           let dataIntro = intro.data(using: .utf8)
           let dataContact = contact.data(using: .utf8)
           let imageData = logo.jpegData(compressionQuality: 0.5)
        
         return Observable<String>.create { (observer) -> Disposable in
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(dataName!, withName: "organizationName")
            multipartFormData.append(dataSlogan!, withName: "slogan")
            multipartFormData.append(dataIntro!, withName: "intro")
            multipartFormData.append(dataContact!, withName: "contact")
            multipartFormData.append(imageData!, withName: "logoImg", fileName: "logo"+".jpeg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: headers).responseJSON(completionHandler: {
                (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let result = json["result"].bool else {return}
                    if result {
                        ProgressHUD.showSuccess()
                        observer.onNext("success")
                    } else {
                        guard let msg = json["msg"].string else { ProgressHUD.showError("错误信息不存在")
                            return
                        }
                        observer.onNext(msg)
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
             return Disposables.create()
                  }
    }
    
    //获取组织详情
    func groupDetail(organizationId:Int) -> Observable<String> {
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        return Observable<String>.create { (observer) -> Disposable in
        AF.request("http://www.chenzhimeng.top/fu-community/organization/\(organizationId)/detail", method: .get, headers: headers).responseJSON {
            [weak self](response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                self?.oneGroup = MyOrganization(json)
                observer.onNext("success")
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    
    //获取组织动态
    func getGroupNews(organizationId:
    Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/organization/\(organizationId)/\(pageNum)/\(length)")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        
        return Observable<String>.create { (observer) -> Disposable in
        
        AF.request(url, method: .get, headers: headers).responseJSON {
            (response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                if let newsJson = json.array {
                    for oneNewJson in newsJson {
                        let news = Infomation(oneNewJson)
                        self.groupNews.append(news)
                    }
                    observer.onNext("success")
                }
                observer.onNext("success")
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    //删除动态
    func deleteNews(newsId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/organization/\(newsId)")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .delete, headers: headers).response(completionHandler: {
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
    
    func uploadNews(organizationId:Int,text:String?,pic:[UIImage]) -> Observable<String>{
        let strId = String(organizationId)
        let idData = strId.data(using: .utf8)
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
                multipartFormData.append(idData!, withName: "organizationId")
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
    
    //编辑动态
    func editNews(newsId:Int, text:String, media:[String],files: [UIImage])  -> Observable<String> {
     let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/organization")!
     let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let strId = String(newsId)
        let dataId = strId.data(using: .utf8)
        let dataText = text.data(using: .utf8)
        let mediaStr = media.description
        let mediaData = mediaStr.data(using: .utf8)
        var jpegData = [Data]()
        for image in files {
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
    
    //加入组织
    func applyForMember(organizationId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization/member")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        let para = ["organizationId":organizationId]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .post,parameters: para, headers: headers).response(completionHandler: {
                           (response) in
                           debugPrint(response)
                 if let statusCode = response.response?.statusCode {
                     if statusCode == 2385 {
                         user.outDated()
                         observer.onNext("会话超时，请刷新再试")
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
    
    //退出组织
    func withdrawMember(organizationId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/organization/member")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        let para = ["organizationId":organizationId]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .delete,parameters: para, headers: headers).response(completionHandler: {
                           (response) in
                           debugPrint(response)
                 if let statusCode = response.response?.statusCode {
                     if statusCode == 2385 {
                         user.outDated()
                         observer.onNext("会话超时，请刷新再试")
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
    
    //获取成员列表
    func getMemberList(organizationId:Int) -> Observable<[String:[UserInfo]]> {
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        return Observable<[String:[UserInfo]]>.create { (observer) -> Disposable in
        AF.request("http://www.chenzhimeng.top/fu-community/user/organization/\(organizationId)", method: .get, headers: headers).responseJSON {
            [weak self](response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                
                var founderList = [UserInfo]()
                var adminList = [UserInfo]()
                var membersList = [UserInfo]()
                let founderJson = json["founder"]
                let founder = UserInfo(founderJson)
                founderList.append(founder)
                
                
                if let admins = json["admins"].array {
                      for adminJson in admins {
                          let admin = UserInfo(adminJson)
                          adminList.append(admin)
                      }
                }
              
                
                if let members = json["members"].array {
                    for memberJson in members {
                        let member = UserInfo(memberJson)
                        membersList.append(member)
                    }
                }
                self?.memberList = ["founder":founderList,"admin":adminList,"member":membersList]
                observer.onNext(self!.memberList)
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    func getApplicationList(organizationId:Int) -> Observable<[UserInfo]> {
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        return Observable<[UserInfo]>.create { (observer) -> Disposable in
        AF.request("http://www.chenzhimeng.top/fu-community/organization/member/application/\(organizationId)", method: .get, headers: headers).responseJSON {
            [weak self](response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                var appList = [UserInfo]()
                if let usersJson = json["applications"].array {
                    for userJson in usersJson {
                        let user = UserInfo(userJson)
                        appList.append(user)
                    }
                    observer.onNext(appList)
                }
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    func applyApplication(organizationId:Int,userId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization/member/application")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        let para = ["organizationId":organizationId,"userId":userId]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .put,parameters: para, headers: headers).response(completionHandler: {
                           (response) in
                           debugPrint(response)
                 if let statusCode = response.response?.statusCode {
                     if statusCode == 2385 {
                         user.outDated()
                         observer.onNext("会话超时，请刷新再试")
                     }
                 }
                if let error = response.error {
                    observer.onError(error)
                }
                
                observer.onNext("已同意")
             })
            return Disposables.create()
            }
    }
    
    func rejectApplication(organizationId:Int,userId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization/member/application")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        let para = ["organizationId":organizationId,"userId":userId]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .delete,parameters: para, headers: headers).response(completionHandler: {
                           (response) in
                           debugPrint(response)
                 if let statusCode = response.response?.statusCode {
                     if statusCode == 2385 {
                         user.outDated()
                         observer.onNext("会话超时，请刷新再试")
                     }
                 }
                if let error = response.error {
                    observer.onError(error)
                }
                
                observer.onNext("已拒绝")
             })
            return Disposables.create()
            }
    }
    
    func removeMember(organizationId:Int,userId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization/member/remove")!
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        let para = ["organizationId":organizationId,"memberId":userId]
        return Observable<String>.create { (observer) -> Disposable in
            AF.request(url, method: .delete,parameters: para, headers: headers).responseJSON { (response) in
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
    
    //委任管理员
    func chooseNewAdmin(organizationId:Int,adminId:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization/admin")!
        let para = ["organizationId":organizationId,"adminId":adminId]
        let headers:HTTPHeaders = ["accessToken":user.accessToken]
        return Observable<String>.create { (observer) -> Disposable in
        AF.request(url, method: .post,parameters: para, headers: headers).responseJSON {
            [weak self](response) in
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
                observer.onError(error)
            }
        }
            return Disposables.create()
            }
    }
    
    
    
    
    
}
