//
//  SchoolError.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/7/16.
//  Copyright © 2020 金含霖. All rights reserved.
//

enum SchoolError: Error {
    case locked
    //功能未解锁
    case outdated
    //token过期
    case differentPlaces

}



/*extension SchoolError {
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
}*/
