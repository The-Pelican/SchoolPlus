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


class InfoViewModel {
    let length = 5
    var pageNum = 0
    var notices:[Notice] = []
    let disposeBag = DisposeBag()
    
    func getNotice() -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/message")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let para = ["pageNum":pageNum,"length":length]
        return Observable<String>.create { (observer) -> Disposable in
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
                            self?.notices.append(noti)
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
    
    func read(id:Int) -> Observable<String> {
        let url = URL(string: "http://www.chenzhimeng.top/fu-community/message/read")!
        let headers: HTTPHeaders = [
            "accessToken": user.accessToken
        ]
        let para = ["messageId":id]
        return Observable<String>.create { (observer) -> Disposable in
        AF.request(url,method:.put,parameters:para, headers: headers).response(completionHandler: {
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
