//
//  StringExtension.swift
//  SchoolPlus
//
//  Created by 金含霖 on 2020/8/26.
//  Copyright © 2020 金含霖. All rights reserved.
//

import Foundation

   func getArrayFromJSONString(jsonString:String) -> NSArray? {
        
       let jsonData:Data = jsonString.data(using: .utf8)!
        
       let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
       /*if array != nil {
           return array as? NSArray
       }*/
       return array as? NSArray
        
   }

 
