//
//  ApiSetDao.swift
//  networkConnect
//
//  Created by 林浩智 on 2015/01/26.
//  Copyright (c) 2015年 apc. All rights reserved.
//

import UIKit

class ApiSetDao: NSObject {
    func getApiResultDao(dic: NSDictionary!) -> (ApiDao?) {
        
        if(dic == nil) {
            return nil
        }
        let apiDao: ApiDao = self.setValues(dic, typeObje: ApiDao()) as ApiDao;
        
        return apiDao
    }
    
    
    //auto input
    func setValues(dic: NSDictionary, typeObje:AnyObject) ->(AnyObject) {

        for (key, value) in dic {
            let keyName = key as String
            
            if(typeObje.respondsToSelector(NSSelectorFromString(keyName))) {
                typeObje.setValue(value, forKey: keyName);
            }
        }
        
        return typeObje
    }
}
