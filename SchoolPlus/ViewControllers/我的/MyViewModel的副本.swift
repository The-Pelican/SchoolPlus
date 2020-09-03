//
//  MyViewModel.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/27.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift

class MyViewModel {
    var pageNum = 0
    var length = 3
    var userList:[UserInfo] = []
    var organizationList:[Organization] = []
    var myGroupList:[Organization] = []
    var newsList:[Infomation] = []
    
    
    
    func getMyGroups()  -> Observable<String> {
      let url = URL(string: "http://www.chenzhimeng.top/fu-community/organization/my")
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
                          let info = Organization(news)
                          self?.myGroupList.append(info)
                      }
                      observer.onNext("success")
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
          })
          return Disposables.create()
      }
     }
    
    
    
    func getSuscribedUsers()  -> Observable<String> {
     let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/subscribed/user/\(pageNum)/\(length)")
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
                         let info = UserInfo(news)
                         self?.userList.append(info)
                     }
                     observer.onNext("success")
                 }
                 
             case .failure(let error):
                 print(error)
                 if let statusCode = response.response?.statusCode {
                     if statusCode == 2385 {
                         user.outDated()
                         observer.onNext("请重新再试")
                     }
                 } else {
                    observer.onError(error)
                 }
             }
         })
         return Disposables.create()
     }
    }
    
    func getSuscribedGroups()  -> Observable<String> {
     let url = URL(string: "http://www.chenzhimeng.top/fu-community/user/subscribed/organization/\(pageNum)/\(length)")
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
                         let info = Organization(news)
                         self?.organizationList.append(info)
                     }
                     observer.onNext("success")
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
         })
         return Disposables.create()
     }
    }
    
    func getMyNews()  -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/news/user/\(user.userId)/\(pageNum)/\(length)")
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
                         self?.newsList.append(info)
                     }
                     observer.onNext("success")
                 }
             case .failure(let error):
                 print(error)
                 if let statusCode = response.response?.statusCode {
                     print(statusCode)
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
    
}
