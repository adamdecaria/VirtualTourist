//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

class FlickrClient : NSObject {
    
    func constructURLForFlickrAPI() -> String {
    
        let flickrURL = "\(FlickrConstants.FlickrWebAddress.SCHEME)\(FlickrConstants.FlickrWebAddress.HOST)\(FlickrConstants.FlickrWebAddress.PATH)?\(FlickrConstants.FlickrAPI.METHOD)\(FlickrConstants.FlickrAPIDetails.METHOD)&\(FlickrConstants.FlickrAPI.API_KEY)\(FlickrConstants.FlickrAPIDetails.API_KEY)&\(FlickrConstants.FlickrAPI.FORMAT)\(FlickrConstants.FlickrAPIDetails.FORMAT)&\(FlickrConstants.FlickrAPI.NOJSONCALLBACK)\(FlickrConstants.FlickrAPIDetails.NOJSONCALLBACK)"
        
        return(flickrURL)
    } // End constructURLForFlickrAPI
    
    func getPhotos(completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error:NSError?) -> Void) {
        
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: constructURLForFlickrAPI())!)
        print("Request: ", request)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            print("Sent request to Flickr server... waiting on data.")
            
            guard (error == nil) else {
                print("Error retrieving photos from Flickr.")
                completionHandler(nil, false, error as NSError?)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Error retrieving photos from Flickr - HTTP response")
                completionHandler(nil, false, error as NSError?)
                return
            }
            
            guard (data != nil) else {
                print("There was an error - no data")
                completionHandler(nil, false, error as NSError?)
                return
            }
            print("Going to parse JSON...")
            self.jsonParser(data: data!, completionHandler: completionHandler)
        }
        
        task.resume()
        
    } // End getPhotos()
    
    func jsonParser(data: Data, completionHandler: (_ result: [String:AnyObject]?, _ success: Bool, _ error: NSError?) -> Void) {
        
        //var parsedJSON = [String:AnyObject]()
        
        do {
            let parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
            //print(parsedResult)
            guard let photos = parsedResult["photos"] as? [String:AnyObject] else {
                print("Cannot find key 'photos'")
                return
            }
            
            guard let photoArray = photos["photo"] as? [[String:AnyObject]] else {
                print("Cannot find photoArray")
                return
            }
            
            for photoDictionary in photoArray {
                print("Title is: ", photoDictionary["title"]!)
            }
            
        } catch {
            print("Error with JSON data")
        }
        
        completionHandler(nil, true, nil)
        
    } // End jsonParser
    
    // MARK: Singleton pattern for a shared FlickrClient instance across the app
    class func sharedInstance() -> FlickrClient {
        struct FlickrSingleton {
            static var sharedFlickrClientInstance = FlickrClient()
        }
        
        return FlickrSingleton.sharedFlickrClientInstance
    } // End sharedInstance()
    
} // End FlickrClient
