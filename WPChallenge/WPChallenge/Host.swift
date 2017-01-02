//
//  Hostel.swift
//  WPChallenge
//
//  Created by Richard Leh on 21/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation

class Host {
    
    var id:Int?
    var title:String?
    var city:String?
    var country:String?
    var rating:Int?
    var reviewsCount:Int?
    var photoUrl:String?
    var price:Int?
    var url:String?
    var accommodationTypeSlug:String?
    var mealsCount:Int?
    var wishListCount:Int?
    var tripsCount:Int?
    var teaserBadge:String?
    var hostingSince:String?
    
    convenience init(dictionary: [String:Any]) {
        self.init()
        
        if let _id = dictionary[Server.worldPackersSearchJSONResponseKeys.id] as? Int{
            id = _id
        }
        if let _title = dictionary[Server.worldPackersSearchJSONResponseKeys.title] as? String{
            title = _title
        }
        if let _city = dictionary[Server.worldPackersSearchJSONResponseKeys.city] as? String{
            city = _city
        }
        if let _country = dictionary[Server.worldPackersSearchJSONResponseKeys.country] as? String{
            country = _country
        }
        if let _photoUrl = dictionary[Server.worldPackersSearchJSONResponseKeys.photoUrl] as? String{
            photoUrl = _photoUrl
        }
        
        if let _rating = dictionary[Server.worldPackersSearchJSONResponseKeys.rating] as? Int{
            rating = _rating
        }

        if let _hostingSince = dictionary[Server.worldPackersSearchJSONResponseKeys.hostingSince] as? String{
            hostingSince = _hostingSince
        }
        
        if let _accommodationTypeSlug = dictionary[Server.worldPackersSearchJSONResponseKeys.accommodationTypeSlug] as? String{
            accommodationTypeSlug = _accommodationTypeSlug
        }
        if let _mealsCount = dictionary[Server.worldPackersSearchJSONResponseKeys.mealsCount] as? Int{
            mealsCount = _mealsCount
        }
        if let _wishListCount = dictionary[Server.worldPackersSearchJSONResponseKeys.wishListCount] as? Int{
            wishListCount = _wishListCount
        }
        if let _tripsCount = dictionary[Server.worldPackersSearchJSONResponseKeys.tripsCount] as? Int{
            tripsCount = _tripsCount
        }
        if let _price = dictionary[Server.worldPackersSearchJSONResponseKeys.price] as? Int{
            price = _price
        }
    }
}
