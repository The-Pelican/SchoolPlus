//
//  InfoViewModel.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/29.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift
import ProgressHUD


class InfoViewModel {
    let length = 20
    var pageNum = 0
    var notices:[Int:[Notice]] = [1:[Notice](),2:[Notice](),3:[Notice](),4:[Notice](),5:[Notice](),6:[Notice]()]
    var typeNotices:[Notice] = []
    let disposeBag = DisposeBag()
    
    func getNotice(type:Int) -> Observable<[Notice]> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/message/\(type)")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let para = ["pageNum":pageNum,"length":length]
        return Observable<[Notice]>.create { (observer) -> Disposable in
            AF.request(url,method:.get,parameters:para, headers: headers).responseJSON(completionHandler: {
                [weak self](response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    if let noticeJson = json.array {
                        for notice in noticeJson {
                            let noti = Notice(notice)
                            for i in 1...6 {
                                if noti.type! == i {
                                    self?.notices[i]?.append(noti)
                                    self?.typeNotices.append(noti)
                                }
                            }
                        }
                        observer.onNext(self!.typeNotices)
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    func moreNotice(type:Int) -> Observable<[Notice]> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/message/\(type)")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let para = ["pageNum":pageNum,"length":length]
        return Observable<[Notice]>.create { (observer) -> Disposable in
            AF.request(url,method:.get,parameters:para, headers: headers).responseJSON(completionHandler: {
                [weak self](response) in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    if let noticeJson = json.array {
                        for notice in noticeJson {
                            let noti = Notice(notice)
                            for i in 1...6 {
                                if noti.type! == i {
                                    self?.notices[i]?.append(noti)
                                }
                            }
                        }
                        observer.onNext(self!.notices[type] ?? [Notice]())
                    }
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            })
            return Disposables.create()
        }
    }
    
    
    
    
    func read(id:Int)  {
        print("read加载")
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/message/read")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let para = ["messageId":id]
        
        AF.request(url,method:.put,parameters:para, headers: headers).response(completionHandler: {
            (response) in
            debugPrint(response)
            if let error = response.error {
                ProgressHUD.showError(error.localizedDescription)
            }
            
        })
    }
    
    func unread() -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/message/unread/count")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        var count = 0
        return Observable<String>.create { (observer) -> Disposable in
        AF.request(url,method:.get,headers: headers).responseJSON(completionHandler: {
            [weak self](response) in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print(value)
                let json = JSON(value)
                for i in 1...6 {
                    if let c = json["\(i)"].int{
                        count += c
                    }
                }
                observer.onNext("\(count)")
                
            case .failure(let error):
                print(error)
                observer.onError(error)
            }
        })
            return Disposables.create()
        }
    }
    
}
