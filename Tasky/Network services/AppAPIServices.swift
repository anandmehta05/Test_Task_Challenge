//
//  AppAPIServices.swift
//  Birdoo
//
//  Created by Credify Technologies Private Limited on 31/01/20.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol AppAPIServicesDelegate {
    
    func apiResponse(response : JSON, reqID: Int)
    func apiError(error : NSError, reqID : Int)
}

var alamoFireManager = Alamofire.Session.default

class AppAPIServices: NSObject {
    
    static var sharedInstance = AppAPIServices()
        
    let REQ_SIGNIN:Int = 1001
    let REQ_STORIES:Int = 1002
    let REQ_CREATE_STORIES:Int = 1003
    let REQ_REJECT_STORIES:Int = 1004
    let REQ_ACCEPT_STORIES:Int = 1005
    
    private override init() {
            
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 120 // seconds
            configuration.timeoutIntervalForResource = 120 //seconds
            
            alamoFireManager =  Alamofire.Session(configuration: configuration)
        }
        
        //MARK: Get Request a service call
        func sendGetRequest(baseURL : String,apiServicesDelegate: AppAPIServicesDelegate, requestID : Int){
            
            print("\n\nAuth request URL:\n \(baseURL)")
            
            alamoFireManager.request(baseURL, method: .get, parameters: nil).responseJSON {
                response in
                
                switch (response.result) {
                    
                case .success(let jsonData):
                    //do json stuff
                    
                    let jsonResponse = JSON(jsonData)
                    apiServicesDelegate.apiResponse(response: jsonResponse,reqID: requestID)
                    
                    print("\n\nAuth request sucess:\n \(baseURL) \n \(jsonResponse)")
                    
                    break
                    
                case .failure(let encodingError):
                    
                    guard  let error = encodingError.underlyingError as NSError? else {
                        apiServicesDelegate.apiError(error: encodingError as NSError ,reqID: requestID)
                        return
                    }
                    
                    if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet {
                        //timeout here
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                    }
                    else if error.code == NSURLErrorNetworkConnectionLost {
                        
                        self.sendGetRequest(baseURL: baseURL, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                    }
                    else
                    {
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                        
                    }
                    
                    print("\n\nAuth request failed with error:\n \(baseURL) \n \(error)")
                    
                    break
                }
            }
        }
        
        
        //MARK: Post Request a service call
        func sendPostRequest(baseURL : String, dictParameters : Dictionary<String, AnyObject>, apiServicesDelegate: AppAPIServicesDelegate, requestID : Int){
            
            print("\n\nAuth request URL:\n \(baseURL)")
            print("\n\nAuth request parameters:\n \(JSON(dictParameters))")
            
            alamoFireManager.request(baseURL, method: .post, parameters: dictParameters).responseJSON {
                response in
                
                switch (response.result) {
                    
                case .success(let jsonData):
                    //do json stuff
                    
                    let jsonResponse = JSON(jsonData)
                    apiServicesDelegate.apiResponse(response: jsonResponse,reqID: requestID)
                    
                    print("\n\nAuth request sucess:\n \(baseURL) \n \(jsonResponse)")
                    
                    break
                    
                case .failure(let encodingError):
                    
                    guard  let error = encodingError.underlyingError as NSError? else {
                        apiServicesDelegate.apiError(error: encodingError as NSError ,reqID: requestID)
                        return
                    }
                    
                    if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet {
                        //timeout here
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                    }
                    else if error.code == NSURLErrorNetworkConnectionLost {
                        
                        self.sendPostRequest(baseURL: baseURL, dictParameters: dictParameters, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                    }
                    else
                    {
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                        
                    }
                    
                    print("\n\nAuth request failed with error:\n \(baseURL) \n \(error)")
                    
                    break
                }
            }
        }
        
        
        //MARK: Post Request with access tocken  service call
        func sendPostRequestWithAccessToken(baseURL : String, dictParameters : Dictionary<String, AnyObject>,accessToken: String, apiServicesDelegate: AppAPIServicesDelegate, requestID : Int){
            
            let header: HTTPHeaders = [HTTPHeader(name: AppConstants.headersKey.accessToken, value: accessToken)]
            
            print("\n\nAuth request URL:\n \(baseURL)")
            print("\n\nAuth request parameters:\n \(JSON(dictParameters))")
            print("\n\nAuth request token:\n \(JSON(header.dictionary))")
            
            alamoFireManager.request(baseURL, method: .post, parameters: dictParameters, headers: header).responseJSON {
                response in
                
                switch (response.result) {
                    
                case .success(let jsonData):
                    //do json stuff
                    
                    let jsonResponse = JSON(jsonData)
                    apiServicesDelegate.apiResponse(response: jsonResponse,reqID: requestID)
                    
                    print("\n\nAuth request sucess:\n \(baseURL) \n \(jsonResponse)")
                    
                    break
                    
                case .failure(let encodingError):
                    
                    guard  let error = encodingError.underlyingError as NSError? else {
                        apiServicesDelegate.apiError(error: encodingError as NSError ,reqID: requestID)
                        return
                    }
                   
                    if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet {
                        //timeout here
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                    }
                    else if error.code == NSURLErrorNetworkConnectionLost {
                        
                        self.sendPostRequestWithAccessToken(baseURL: baseURL, dictParameters: dictParameters, accessToken: accessToken, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                    }
                    else
                    {
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                        
                    }
                    
                    print("\n\nAuth request failed with error:\n \(baseURL) \n \(error)")
                    
                    break
                }
            }
        }
        
        //MARK: Get Request with access tocken  service call
        func sendGetRequestWithAccessToken(baseURL : String,accessToken: String, apiServicesDelegate: AppAPIServicesDelegate, requestID : Int){
            
            let header: HTTPHeaders = [HTTPHeader(name: AppConstants.headersKey.accessToken, value: accessToken)]
            
            print("\n\nAuth request URL:\n \(baseURL)")
            print("\n\nAuth request token:\n \(JSON(header.dictionary))")
            
            alamoFireManager.request(baseURL, method: .get, parameters: nil, headers: header).responseJSON {
                response in
                
                switch (response.result) {
                    
                case .success(let jsonData):
                    //do json stuff
                    
                    let jsonResponse = JSON(jsonData)
                    
                    apiServicesDelegate.apiResponse(response: jsonResponse,reqID: requestID)

                    
                    print("\n\nAuth request sucess:\n \(baseURL) \n \(jsonResponse)")
                    
                    break
                    
                case .failure(let encodingError):
                    
                    guard  let error = encodingError.underlyingError as NSError? else {
                        apiServicesDelegate.apiError(error: encodingError as NSError ,reqID: requestID)
                        return
                    }
                    
                    if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet {
                        //timeout here
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                    }
                    else if error.code == NSURLErrorNetworkConnectionLost {
                        
                        self.sendGetRequestWithAccessToken(baseURL: baseURL, accessToken: accessToken, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                    }
                    else
                    {
                        
                        apiServicesDelegate.apiError(error: error ,reqID: requestID)
                        
                    }
                    
                    print("\n\nAuth request failed with error:\n \(baseURL) \n \(error)")
                    
                    break
                }
            }
        }
    
    //MARK: Put Request with access tocken  service call
    func sendPutRequestWithAccessToken(baseURL : String, dictParameters : Dictionary<String, AnyObject>,accessToken: String, apiServicesDelegate: AppAPIServicesDelegate, requestID : Int){
        
        let header: HTTPHeaders = [HTTPHeader(name: AppConstants.headersKey.accessToken, value: accessToken)]
        
        print("\n\nAuth request URL:\n \(baseURL)")
        print("\n\nAuth request parameters:\n \(JSON(dictParameters))")
        print("\n\nAuth request token:\n \(JSON(header.dictionary))")
        
        alamoFireManager.request(baseURL, method: .put, parameters: dictParameters, headers: header).responseJSON {
            response in
            
            switch (response.result) {
                
            case .success(let jsonData):
                //do json stuff
                
                let jsonResponse = JSON(jsonData)
                apiServicesDelegate.apiResponse(response: jsonResponse,reqID: requestID)
                
                print("\n\nAuth request sucess:\n \(baseURL) \n \(jsonResponse)")
                
                break
                
            case .failure(let encodingError):
                
                guard  let error = encodingError.underlyingError as NSError? else {
                    apiServicesDelegate.apiError(error: encodingError as NSError ,reqID: requestID)
                    return
                }
               
                if error.code == NSURLErrorTimedOut || error.code ==  NSURLErrorNotConnectedToInternet {
                    //timeout here
                    
                    apiServicesDelegate.apiError(error: error ,reqID: requestID)
                }
                else if error.code == NSURLErrorNetworkConnectionLost {
                    
                    self.sendPostRequestWithAccessToken(baseURL: baseURL, dictParameters: dictParameters, accessToken: accessToken, apiServicesDelegate: apiServicesDelegate, requestID: requestID)
                }
                else
                {
                    
                    apiServicesDelegate.apiError(error: error ,reqID: requestID)
                    
                }
                
                print("\n\nAuth request failed with error:\n \(baseURL) \n \(error)")
                
                break
            }
        }
    }
}
