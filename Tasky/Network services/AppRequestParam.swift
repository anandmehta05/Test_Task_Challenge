//
//  AppRequestParam.swift
//  Birdoo
//
//  Created by Credify Technologies Private Limited on 31/01/20.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit
import SwiftyJSON

class AppRequestParam: NSObject
{
    static var sharedInstance = AppRequestParam()
    
    // MARK: Signin Param
    func param_Signin(email: String, password: String, isAdmin: Bool) -> Dictionary<String, AnyObject> {
        
        let param: [String : AnyObject] = [
            "email" : email as AnyObject,
            "password" : password as AnyObject,
            "isAdmin" : isAdmin as AnyObject
        ]
        return param
    }
    
    // MARK: Create Story Param
    func param_CreateStory(summary: String, description: String, type: String, complexity: String, estimatedHrs: String, cost: String) -> Dictionary<String, AnyObject> {
        
        let param: [String : AnyObject] = [
            "summary" : summary as AnyObject,
            "description" : description as AnyObject,
            "type" : type as AnyObject,
            "complexity" : complexity as AnyObject,
            "estimatedHrs" : estimatedHrs as AnyObject,
            "cost" : cost as AnyObject
        ]
        
        return param
    }
    
    // MARK: Accept Reject Story Param
    func param_AcceptRejectStory(storyId: Int, status: String) -> Dictionary<String, AnyObject> {
        
        let param: [String : AnyObject] = [
            "id" : storyId as AnyObject,
            "status" : status as AnyObject
        ]
        return param
    }
}
