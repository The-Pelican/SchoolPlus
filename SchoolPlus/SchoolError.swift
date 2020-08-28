//
//  SchoolError.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/16.
//  Copyright © 2020 金含霖. All rights reserved.
//

enum SchoolError: Error {
    case unexpected
    //获取验证码失败
    case codeFail(String)
    //登录失败
    case loginFail(String)
    //设置密码失败
    case setFail(String)
    //认证失败
    case authFail(String)
    //Alamofire
    case afError
}

extension SchoolError {
    var localizedDescription: String{
        switch self {
        case .unexpected:
            return "未获得应有信息，请联系开发人员"
        case .codeFail(let s):
            return s
        case .loginFail(let s):
            return s
        case .setFail(let s):
            return s
        case .authFail(let s):
            return s
        case .afError:
            return "服务器异常"
        }
    }
}
