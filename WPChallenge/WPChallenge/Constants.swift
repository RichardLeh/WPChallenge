//
//  Constants.swift
//  WPChallenge
//
//  Created by Richard Leh on 21/12/2016.
//  Copyright © 2016 Richard Leh. All rights reserved.
//

import Foundation

//https://staging-worldpackersplatform.herokuapp.com/api/search?q=TEXT

// MARK: Constants
struct Server {
    
    // MARK: API TMDB MOVIE
    struct worldpackersApi {
        static let apiScheme = "https"
        static let apiHost = "staging-worldpackersplatform.herokuapp.com"
        static let apiPath = "/api"
        static let apiMethod = "/search/"
    }
    
    struct worldpackersApiKeys {
        static let query = "q"
        static let page = "page"
    }
    
    struct worldPackersHeadersKeys {
        static let accept = "Accept"
        static let authorization = "Authorization"
    }
    struct worldPackersHeadersValues {
        static let accept = "application/vnd.worldpackers.com.v6+json"
        static let authorization = "bearer 9e5a86cfca45eba00668e1baf15fd8dd65c15ad760e00845b81995d242844cdd"
    }
    
    struct worldPackersJSONResponseKeys {
        static let id = "id"
        static let title = "title"
        static let city = "city"
        static let country = "country"
        static let rating = "rating"
        static let reviewsCount = "reviews_count"
        static let photoUrl = "photo_url"
        static let price = "price"
        static let url = "url"
        static let accommodationTypeSlug = "accommodation_type_slug"
        static let mealsCount = "meals_count"
        static let wishListCount = "wish_list_count"
        static let tripsCount = "trips_count"
        static let teaserBadge = "teaser_badge"
        static let hostingSince = "hosting_since"
    }
}

enum Colors: String{
    case defaultColor = "#158cba"
}

enum AppConstants: Int{
    case ratingMax = 5
}

enum AppSegues: String{
    case showResult = "showResultSegue"
}
