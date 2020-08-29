//
//  Stories.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import Foundation
import SwiftyJSON


class Stories : NSObject, NSCoding{

    var complexity : String!
    var cost : Int!
    var createdBy : Int!
    var descriptionField : String!
    var estimatedHrs : Int!
    var id : Int!
    var summary : String!
    var type : String!
    var status: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        complexity = json["complexity"].stringValue
        cost = json["cost"].intValue
        createdBy = json["createdBy"].intValue
        descriptionField = json["description"].stringValue
        estimatedHrs = json["estimatedHrs"].intValue
        id = json["id"].intValue
        summary = json["summary"].stringValue
        type = json["type"].stringValue
        status = json["status"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if complexity != nil{
            dictionary["complexity"] = complexity
        }
        if cost != nil{
            dictionary["cost"] = cost
        }
        if createdBy != nil{
            dictionary["createdBy"] = createdBy
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if estimatedHrs != nil{
            dictionary["estimatedHrs"] = estimatedHrs
        }
        if id != nil{
            dictionary["id"] = id
        }
        if summary != nil{
            dictionary["summary"] = summary
        }
        if type != nil{
            dictionary["type"] = type
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        complexity = aDecoder.decodeObject(forKey: "complexity") as? String
        cost = aDecoder.decodeObject(forKey: "cost") as? Int
        createdBy = aDecoder.decodeObject(forKey: "createdBy") as? Int
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        estimatedHrs = aDecoder.decodeObject(forKey: "estimatedHrs") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        summary = aDecoder.decodeObject(forKey: "summary") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if complexity != nil{
            aCoder.encode(complexity, forKey: "complexity")
        }
        if cost != nil{
            aCoder.encode(cost, forKey: "cost")
        }
        if createdBy != nil{
            aCoder.encode(createdBy, forKey: "createdBy")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if estimatedHrs != nil{
            aCoder.encode(estimatedHrs, forKey: "estimatedHrs")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if summary != nil{
            aCoder.encode(summary, forKey: "summary")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }

}

