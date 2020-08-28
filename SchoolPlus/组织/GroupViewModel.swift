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
import ProgressHUD

class GroupViewModel {
    var groups = [Organization]()
    
    //查找组织
    func searchGroups(text:String) {
        let headers:HTTPHeaders = ["accessToken":user.accessToken, "refreshToken":user.refreshToken]
        AF.request("http://www.chenzhimeng.top/organization/\(text)", method: .get, parameters: nil, headers: headers).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchMyGroups(text:String) {
        let headers:HTTPHeaders = ["accessToken":user.accessToken, "refreshToken":user.refreshToken]
        AF.request("http://www.chenzhimeng.top/organization/\(text)", method: .get, parameters: nil, headers: headers).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createGroup(name:Data,logo:Data,slogan:Data,intro:Data) {
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(name, withName: "organizationName")
            multipartFormData.append(slogan, withName: "slogan")
            multipartFormData.append(intro, withName: "intro")
            multipartFormData.append(logo, withName: "logo", fileName: "logo"+".jpeg", mimeType: "image/jpeg")
            }, to: "http://www.chenzhimeng.top/organization").responseJSON(completionHandler: {
                (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let result = json["result"].bool else {return}
                    if result {
                        ProgressHUD.showSuccess()
                    } else {
                        guard let msg = json["msg"].string else { ProgressHUD.showError("错误信息不存在")
                            return
                        }
                        ProgressHUD.showError(msg)
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }
}
