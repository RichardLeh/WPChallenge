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
    
    init(dictionary: [String:Any]) {
        if let _id = dictionary[Server.worldPackersJSONResponseKeys.id] as? Int{
            id = _id
        }
        if let _title = dictionary[Server.worldPackersJSONResponseKeys.title] as? String{
            title = _title
        }
        if let _city = dictionary[Server.worldPackersJSONResponseKeys.city] as? String{
            city = _city
        }
        if let _country = dictionary[Server.worldPackersJSONResponseKeys.country] as? String{
            country = _country
        }
        if let _photoUrl = dictionary[Server.worldPackersJSONResponseKeys.photoUrl] as? String{
            photoUrl = _photoUrl
        }
        
        if let _rating = dictionary[Server.worldPackersJSONResponseKeys.rating] as? Int{
            rating = _rating
        }
        
        if let _accommodationTypeSlug = dictionary[Server.worldPackersJSONResponseKeys.accommodationTypeSlug] as? String{
            accommodationTypeSlug = _accommodationTypeSlug
        }
        if let _mealsCount = dictionary[Server.worldPackersJSONResponseKeys.mealsCount] as? Int{
            mealsCount = _mealsCount
        }
        if let _wishListCount = dictionary[Server.worldPackersJSONResponseKeys.wishListCount] as? Int{
            wishListCount = _wishListCount
        }
        if let _tripsCount = dictionary[Server.worldPackersJSONResponseKeys.tripsCount] as? Int{
            tripsCount = _tripsCount
        }
        if let _price = dictionary[Server.worldPackersJSONResponseKeys.price] as? Int{
            price = _price
        }
        
    }
    
    init(with id:Int, title: String, city: String, country:String, rating:String?, reviewsCount:Int, photoUrl:String, price:Int, url:String, accommodationTypeSlug:String, mealsCount:Int, wishListCount:Int, teaserBadge:String, hostingSince:String) {
        
    }
}

/*
{
    "id": 10,
    "title": "YOho",
    "city": "São Paulo",
    "country": "Brazil",
    "rating": null,
    "reviews_count": 0,
    "photo_url": "https://s3.amazonaws.com/worldpackers_staging/volunteer_positions/photos/000/000/010/main/10.jpg",
    "price": 8000,
    "url": "https://staging-worldpackersplatform.herokuapp.com/api/volunteer_positions/10",
    "accommodation_type_slug": "shared_dorm",
    "meals_count": 1,
    "wish_list_count": 1,
    "trips_count": 5,
    "teaser_badge": "",
    "hosting_since": "2014-12-04"
}
*/
