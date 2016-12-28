//
//  HostDetail.swift
//  WPChallenge
//
//  Created by Richard Leh on 27/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation

class HostDetail {
    
    var id:Int?
    var title:String?
    var city:String?
    var country:String?
    var description:String?
    var rating:Int?
    var price:Int?
    var photos:[String]?
    
    init(dictionary: [String:Any]) {
        if let _id = dictionary[Server.worldPackersDetailJSONResponseKeys.id] as? Int{
            id = _id
        }
        if let _title = dictionary[Server.worldPackersDetailJSONResponseKeys.title] as? String{
            title = _title
        }
        if let _city = dictionary[Server.worldPackersDetailJSONResponseKeys.city] as? String{
            city = _city
        }
        if let _country = dictionary[Server.worldPackersDetailJSONResponseKeys.country] as? String{
            country = _country
        }
        if let _description = dictionary[Server.worldPackersDetailJSONResponseKeys.description] as? String{
            description = _description
        }
        if let _price = dictionary[Server.worldPackersDetailJSONResponseKeys.price] as? Int{
            price = _price
        }
        if let _rating = dictionary[Server.worldPackersDetailJSONResponseKeys.rating] as? Int{
            rating = _rating
        }
    }
}
