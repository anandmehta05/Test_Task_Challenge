//
//  User.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import Foundation
import SwiftyJSON


class User : NSObject, NSCoding{

    var firstName : String!
    var id : Int!
    var lastName : String!
    var role : String!
    var token : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        firstName = json["firstName"].stringValue
        id = json["id"].intValue
        lastName = json["lastName"].stringValue
        role = json["role"].stringValue
        token = json["token"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if firstName != nil{
            dictionary["firstName"] = firstName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastName != nil{
            dictionary["lastName"] = lastName
        }
        if role != nil{
            dictionary["role"] = role
        }
        if token != nil{
            dictionary["token"] = token
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        role = aDecoder.decodeObject(forKey: "role") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if firstName != nil{
            aCoder.encode(firstName, forKey: "firstName")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "lastName")
        }
        if role != nil{
            aCoder.encode(role, forKey: "role")
        }
        if token != nil{
            aCoder.encode(token, forKey: "token")
        }

    }

}

