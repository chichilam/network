//
//  NetWork.swift
//  networkConnect
//
//  Created by 林浩智 on 2015/01/26.
//  Copyright (c) 2015年 apc. All rights reserved.
//

import UIKit

class NetWork: NSObject {
    
    /**
    connect by get
    
    :param: apiUrlStr url
    :param: callback  result
    */
    class func connetByGet(urlStr: String!, callback: (AnyObject, NSError!) -> ()) {
        
        let url:NSURL = NSURL(string: urlStr)!
                
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.timeoutInterval = 20
        request.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if(error == nil) {
                var jsonResutl: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                callback(jsonResutl,nil)
            } else {
               callback(data,error)
            }
          }
    }
    
    /**
    connect by post
    
    :param: apiUrlStr url
    :param: bodyStr   post data
    :param: callback  resutl
    */
    class func connectByPost(urlStr: String!, bodyStr: String!, callback:(AnyObject, NSError!) -> ()) {
        let url:NSURL = NSURL(string: urlStr)!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        let bodyData = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.timeoutInterval = 20
        request.HTTPBody = bodyData
        request.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if(error == nil) {
                var jsonResutl: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                callback(jsonResutl,nil)
            } else {
                callback(data,error)
            }
        }
    }
    
    /**
    connect by get with session
    
    :param: apiUrlStr url
    :param: callback  result
    */
    class func connectSessionByGet(urlStr: String!, callback: (AnyObject, NSError!) -> ()) {
        
        let url:NSURL = NSURL(string: urlStr)!
        
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
    
    class func connectSessionByPost(urlStr: String!, bodyStr: String!, callback: (AnyObject, NSError!) -> ()) {
        let url:NSURL = NSURL(string: urlStr)!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        let bodyData = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.timeoutInterval = 20
        request.HTTPBody = bodyData
        request.HTTPShouldHandleCookies = false
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
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
