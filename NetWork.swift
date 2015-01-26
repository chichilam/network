//
//  NetWork.swift
//  networkConnect
//
//  Created by 林浩智 on 2015/01/26.
//  Copyright (c) 2015年 apc. All rights reserved.
//

import UIKit

class NetWork: NSObject {
    
    func connetByGet(apiUrlStr: String!, callback: (AnyObject, NSError!) -> ()) {
        
        let url:NSURL = NSURL(string: apiUrlStr)!
                
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler:{data, response, error in
            
            if(error == nil) {
              
                //convert json data to dictionary
                var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                println(dict)
                
                callback(dict, nil)
                
            } else {
                callback(data, error)
            }
        })
        
        task.resume()
    }
   
}
