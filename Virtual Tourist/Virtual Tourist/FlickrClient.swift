//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

class FlickrClient : NSObject {
    
    let session = URLSession.shared
    
    func constructURLForFlickrAPI() {
    
        let flickrURL = "\(FlickrConstants.FlickrWebAddress.SCHEME)\(FlickrConstants.FlickrWebAddress.HOST)\(FlickrConstants.FlickrWebAddress.PATH)?\(FlickrConstants.FlickrAPI.METHOD)\(FlickrConstants.FlickrAPIDetails.METHOD)&\(FlickrConstants.FlickrAPI.API_KEY)\(FlickrConstants.FlickrAPIDetails.API_KEY)&\(FlickrConstants.FlickrAPI.FORMAT)\(FlickrConstants.FlickrAPIDetails.FORMAT)&\(FlickrConstants.FlickrAPI.NOJSONCALLBACK)\(FlickrConstants.FlickrAPIDetails.NOJSONCALLBACK)"
        
        print(flickrURL)
    } // End constructURLForFlickrAPI
    
    // MARK: Singleton pattern for a shared FlickrClient instance across the app
    class func sharedInstance() -> FlickrClient {
        struct FlickrSingleton {
            static var sharedFlickrClientInstance = FlickrClient()
        }
        
        return FlickrSingleton.sharedFlickrClientInstance
    } // End sharedInstance()
    
} // End FlickrClient
