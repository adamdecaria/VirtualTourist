//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

struct FlickrConstants {
    
    struct FlickrWebAddress {
        static let SCHEME = "https://"
        static let HOST = "api.flickr.com"
        static let PATH = "/services/rest"
    }
    
    struct FlickrAPI {
        static let METHOD = "method="
        static let API_KEY = "api_key="
        static let LAT = "lat="
        static let LON = "lon="
        static let FORMAT = "format="
        static let NOJSONCALLBACK = "nojsoncallback="
        
    }
    
    struct FlickrAPIDetails {
        static let METHOD = "flickr.photos.search"
        static let API_KEY = "707b3719e24370d2d18b60457b84ae6e"
        static let FORMAT = "json"
        static let NOJSONCALLBACK = "1"
        
    }
    
} // End FlickrConstants
