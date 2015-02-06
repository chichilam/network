//
//  NetWork.swift
//  networkConnect
//
//  Created by 林浩智 on 2015/01/26.
//  Copyright (c) 2015年 apc. All rights reserved.
//

import UIKit

protocol NetWorkDelegate : class {
    func connectionDidFinishLoading(apiName:String!, resutl:AnyObject?, error:NSError?)
}

class NetWork: NSObject {
    
    var receiveData: NSMutableData?
    var apiName: String?
    weak var delegate: NetWorkDelegate? = nil
    
    /**
    connet by get using delegate
    
    :param: urlStr         url string
    :param: callingApiName api recognition
    */
    func connectByGet(urlStr: String!, callingApiName: String!) {
        
        receiveData = NSMutableData()
        apiName = callingApiName
        
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        var request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        
        request.HTTPShouldHandleCookies = false
        
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        
        connection.start()
    }
    
    /**
    connet by post using delegate
    
    :param: urlStr         url string
    :param: postStr        body string
    :param: callingApiName api recognition
    */
    func connectByPost(urlStr: String!, bodyStr: String!, callingApiName: String!) {
        receiveData = NSMutableData()
        apiName = callingApiName
        
        let url = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        let bodyData = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        var request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        
        request.HTTPBody = bodyData
        request.HTTPShouldHandleCookies = false
        
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
        
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        receiveData?.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        delegate?.connectionDidFinishLoading(apiName, resutl: nil, error: error)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var error: NSError? = nil
        
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(receiveData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        delegate?.connectionDidFinishLoading(apiName, resutl: jsonResult, error: error)
    }
    
    /**
    connect by get
    
    :param: apiUrlStr url
    :param: callback  result
    */
    class func connetByGet(urlStr: String!, callback: (AnyObject?, NSError?) -> ()) {
        
        let url:NSURL = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
                
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        
        request.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if(error == nil) {
                
                var jsonError : NSError?
                
                var jsonResutl: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(jsonResutl,jsonError)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(data,error)
                })
            }
          }
    }
    
    /**
    connect by post
    
    :param: apiUrlStr url
    :param: bodyStr   post data
    :param: callback  resutl
    */
    class func connectByPost(urlStr: String!, bodyStr: String!, callback:(AnyObject?, NSError?) -> ()) {
        let url:NSURL = NSURL(string: urlStr)!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        
        let bodyData = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = bodyData
        request.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if(error == nil) {
                
                var jsonError : NSError?
                
                var jsonResutl: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(jsonResutl,jsonError)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(data,error)
                })
            }
        }
    }
    
    /**
    connect by get with session
    
    :param: apiUrlStr url
    :param: callback  result
    */
    class func connectSessionByGet(urlStr: String!, callback: (AnyObject?, NSError?) -> ()) {
        
        let url:NSURL = NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler:{data, response, error in
            
            if(error == nil) {
                
                var jsonError : NSError?
                
                //convert json data to dictionary
                var jsonResutl = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(jsonResutl,jsonError)
                })
                
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(data,error)
                })
            }
        })
        
        task.resume()
    }
    
    class func connectSessionByPost(urlStr: String!, bodyStr: String!, callback: (AnyObject?, NSError?) -> ()) {
        let url:NSURL = NSURL(string: urlStr)!
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        
        let bodyData = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = bodyData
        request.HTTPShouldHandleCookies = false
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if(error == nil) {
                
                var jsonError : NSError?
                
                //convert json data to dictionary
                var jsonResutl = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(jsonResutl,jsonError)
                })
                
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(data,error)
                })
            }
        })
        
        task.resume()
    }
   
}
