//
//  ApiHandler.swift
//  EazyCarCare
//
//  Created by Umesh Chauhan on 27/04/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import Foundation
import Alamofire



class ApiHandler{
    
    func sendPostRequest(url : String, parameters : Parameters, completionHandler: @escaping (_ response : [String : AnyObject],_ error : Error?) -> Void)  {
        
    
            
        Alamofire.request(url,method:.post,parameters: parameters,encoding:URLEncoding.httpBody)
            .responseJSON(completionHandler: { response in
                
//
//                debugPrint(response)
//                
                if((response.result.value) != nil) {
                    
    
                    
                    // 2. now pass your variable / result to completion handler
                    completionHandler(response.result.value as! [String:AnyObject],nil)
                    
    
                } else {
                    //response.error and response.result.error both are same
                    completionHandler([:],response.error)
                }
            })
        
        
    }
    
    func sendPostRequestTypeSecond(url : String, parameters : Parameters, completionHandler: @escaping (_ response : NSArray,_ error : Error?) -> Void)  {
        
        
        
        Alamofire.request(url,method:.post,parameters: parameters,encoding:URLEncoding.httpBody)
            .responseJSON(completionHandler: { response in
                
                //
                //                debugPrint(response)
                //
                if((response.result.value) != nil) {
                    
                    
                    
                    // 2. now pass your variable / result to completion handler
                    completionHandler(response.result.value as! NSArray,nil)
                    
                    
                } else {
                    //response.error and response.result.error both are same
                    completionHandler([],response.error!)
                }
            })
        
        
    }

    
    func makeParameters (data : [String:AnyObject]) -> Parameters{
        return data as Parameters
    }
    
    func makeParameters (data : [String:Any]) -> Parameters{
        return data as Parameters
    }
    
        
    func sendPostRequest(url : String,  completionHandler: @escaping (_ response : [String : AnyObject],_ error : Error?) -> Void)  {

        Alamofire.request(url,method:.post)
            .responseJSON(completionHandler: { response in
                
               
                
                if((response.result.value) != nil) {
                    
                    
                    
                    // 2. now pass your variable / result to completion handler
                    completionHandler(response.result.value as! [String:AnyObject],nil)
                    
                    
                } else {
                    //response.error and response.result.error both are same
                    completionHandler([:],response.error)
                }
            })
        
        
    }
    
    func sendPostRequestWithJsonBody (url:String,parameters : Parameters, completionHandler: @escaping (_ response : [String : AnyObject?],_ error: Error?) -> Void){
        
        let url = URL(string: url)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        print(parameters)
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // No-op
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
               
        Alamofire.request(urlRequest).responseJSON(completionHandler: {response in
                      
            if((response.result.value) != nil) {
                
                
              
                // 2. now pass your variable / result to completion handler
                completionHandler(response.result.value as! [String:AnyObject?],nil)
                
                
            } else {
                completionHandler([:],response.error)
            }

        
        })
        
    }
    
    func sendGetRequest(url : String, completionHandler: @escaping (_ response : [String : AnyObject],_ error:Error?) -> Void)  {
        
        
        
        Alamofire.request(url,method:.get,encoding:URLEncoding.httpBody)
            .responseJSON(completionHandler: { response in
                
                //
                //                debugPrint(response)
                //
                if((response.result.value) != nil) {
                    
                    
                    
                    // 2. now pass your variable / result to completion handler
                    completionHandler(response.result.value as! [String:AnyObject],nil)
                    
                    
                } else {
                    completionHandler([:],response.error)
                }
            })
        
        
    }
    
    func GetResponseWithoutJSON(url : String, completionHandler: @escaping (_ response : String,_ error:Error?) -> Void)  {
        
        
        
        Alamofire.request(url,method:.get,encoding:URLEncoding.httpBody)
            .responseString(completionHandler: { response in
                
                //
                //                debugPrint(response)
                //
                if((response.result.value) != nil) {
                    
                    
                    
                    // 2. now pass your variable / result to completion handler
                    completionHandler(response.result.value!,nil)
                    
                    
                } else {
                    completionHandler("",response.error)
                }
            })
        
        
    }

    
    
    
       
}
