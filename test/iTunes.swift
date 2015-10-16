//
//  iTunes.swift
//  test
//
//  Created by Mohammad Awwad on 10/16/15.
//  Copyright © 2015 Awwadeto. All rights reserved.
//

import Foundation
import UIKit


class iTunes : NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGet( completionHandler : (data:
        [[String: AnyObject]]? , errorString: String?) -> Void) -> NSURLSessionDataTask{
            
            let urlString = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=30/json"
            let url = NSURL(string: urlString)!
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if let error = downloadError {
                    print("Could not complete the request \(error)")
                } else {
                    
                    do {
                        let parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        if let jsonData = parsedResult.valueForKey("feed")?.valueForKey("entry") as? [[String: AnyObject]] {
                            completionHandler(data: jsonData, errorString: nil)
                        }
                    } catch {}
                    
                }
            }
            
            task.resume()
            return task
    }
    
    func taskForImage(path : String , completionHandler : (data:
        NSData? , errorString: String?) -> Void) -> NSURLSessionDataTask{
            let urlString = path
            let url = NSURL(string: urlString)!
            let request = NSURLRequest(URL: url)
            
            let task = session.dataTaskWithRequest(request) {data, response, downloadError in
                if let error = downloadError {
                    print("Could not complete the request \(error)")
                } else {
                    completionHandler(data: data, errorString: nil)
                }
                
            }
            task.resume()
            return task
    }
    
    class func sharedInstance() -> iTunes {
        struct Singleton {
            static var sharedInstance = iTunes()
        }
        return Singleton.sharedInstance
    }
    
    struct Caches {
        static let imagecache = imageCache()
    }
}