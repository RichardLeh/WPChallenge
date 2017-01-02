//
//  HostDetail.swift
//  WPChallenge
//
//  Created by Richard Leh on 27/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation
import CoreLocation

class HostDetail {
    
    var id:Int?
    
    var photos:[String]?
    
    // title
    var title:String?
    var type:String?
    var city:String?
    var state:String?
    var country:String?
    
    var reviews:Dictionary<String, Any>?
    var rating:Int?
    
    var price:Int?
    
    // the experience
    var description:String?
    
    // what we ask for
    var hours:Dictionary<String, Any>?
    var daysOff:Int?
    var minimumTimeToStay:Dictionary<String, Any>?
    var maximumTimeToStay:Dictionary<String, Any>?
    var requiredLanguages:[Dictionary<String, Any>]?
    
    // map
    var geolocation:CLLocationCoordinate2D?
    
    // the host
    var hostName:String?
    var hostPhotoUrl:String?
    var hostResponseRate:Double?
    var hostResponseTime:Double?
    var hostDescription:String?
    
    convenience init(dictionary: [String:Any]) {
        self.init()
        
        if let _id = dictionary[Server.worldPackersDetailJSONResponseKeys.id] as? Int{
            id = _id
        }
        
        // photos
        if let _photos = dictionary[Server.worldPackersDetailJSONResponseKeys.photos] as? [String]{
            photos = _photos
        }
        
        // title
        if let _title = dictionary[Server.worldPackersDetailJSONResponseKeys.title] as? String{
            title = _title
        }
        if let _city = dictionary[Server.worldPackersDetailJSONResponseKeys.city] as? String{
            city = _city
        }
        if let _state = dictionary[Server.worldPackersDetailJSONResponseKeys.state] as? String{
            state = _state
        }
        if let _country = dictionary[Server.worldPackersDetailJSONResponseKeys.country] as? String{
            country = _country
        }
        if let _price = dictionary[Server.worldPackersDetailJSONResponseKeys.price] as? Int{
            price = _price
        }
        if let _reviews = dictionary[Server.worldPackersDetailJSONResponseKeys.reviews] as? Dictionary<String, Any>{
            reviews = _reviews
            if let _rating = _reviews[Server.worldPackersDetailJSONResponseKeys.rating] as? Int{
                rating = _rating
            }
        }
        
        // the experience
        if let _description = dictionary[Server.worldPackersDetailJSONResponseKeys.description] as? String{
            description = _description
        }
        
        // what we ask for
        if let _hours = dictionary[Server.worldPackersDetailJSONResponseKeys.hours] as? Dictionary<String, Any>{
            hours = _hours
        }
        if let _daysOff = dictionary[Server.worldPackersDetailJSONResponseKeys.daysOff] as? Int?{
            daysOff = _daysOff
        }
        if let _minimumTimeToStay = dictionary[Server.worldPackersDetailJSONResponseKeys.minimumTimeToStay] as? Dictionary<String, Any>{
            minimumTimeToStay = _minimumTimeToStay
        }
        if let _maximumTimeToStay = dictionary[Server.worldPackersDetailJSONResponseKeys.maximumTimeToStay] as? Dictionary<String, Any>{
            maximumTimeToStay = _maximumTimeToStay
        }
        if let _requiredLanguages = dictionary[Server.worldPackersDetailJSONResponseKeys.requiredLanguages] as? [Dictionary<String, Any>]{
            requiredLanguages = _requiredLanguages
        }
        
        // map
        if  let _latitude  = dictionary[Server.worldPackersDetailJSONResponseKeys.latitude] as? Float,
            let _longitude = dictionary[Server.worldPackersDetailJSONResponseKeys.longitude] as? Float {
            geolocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(_latitude), longitude: CLLocationDegrees(_longitude))
        }
        
        // the host
        if let host = dictionary[Server.worldPackersDetailJSONResponseKeys.host] as? Dictionary<String, Any>{
            if let _hostName = host[Server.worldPackersDetailJSONResponseKeys.hostName] as? String{
                hostName = _hostName
            }
            if let _hostPhotoUrl = host[Server.worldPackersDetailJSONResponseKeys.hostPhotoUrl] as? String{
                hostPhotoUrl = _hostPhotoUrl
            }
            if let _hostResponseRate = host[Server.worldPackersDetailJSONResponseKeys.hostResponseRate] as? Double{
                hostResponseRate = _hostResponseRate
            }
            if let _hostResponseTime = host[Server.worldPackersDetailJSONResponseKeys.hostResponseTime] as? Double{
                hostResponseTime = _hostResponseTime
            }
            if let _hostDescription = host[Server.worldPackersDetailJSONResponseKeys.hostDescription] as? String{
                hostDescription = _hostDescription
            }
        }
    }
}
