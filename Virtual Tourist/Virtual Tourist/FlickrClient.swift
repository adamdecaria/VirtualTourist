//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-25.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient : NSObject {
    
    private var latitude: String = ""
    private var longitude: String = ""
    
    var photoURLArray = [String]()
    var imageArray = [UIImage]()
    
    func constructURLForFlickrAPI() -> String {
    
        let flickrURL = "\(FlickrConstants.FlickrWebAddress.SCHEME)\(FlickrConstants.FlickrWebAddress.HOST)\(FlickrConstants.FlickrWebAddress.PATH)?\(FlickrConstants.FlickrAPI.METHOD)\(FlickrConstants.FlickrAPIDetails.METHOD)&\(FlickrConstants.FlickrAPI.API_KEY)\(FlickrConstants.FlickrAPIDetails.API_KEY)&\(FlickrConstants.FlickrAPI.LAT)\(self.latitude)&\(FlickrConstants.FlickrAPI.LON)\(self.longitude)&\(FlickrConstants.FlickrAPI.FORMAT)\(FlickrConstants.FlickrAPIDetails.FORMAT)&\(FlickrConstants.FlickrAPI.NOJSONCALLBACK)\(FlickrConstants.FlickrAPIDetails.NOJSONCALLBACK)"
        
        return(flickrURL)
    } // End constructURLForFlickrAPI
    
    func getPinLocation(lat: String, lon: String) {
        self.latitude = lat
        self.longitude = lon
    }
    
    func getPhotos(completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: NSError?) -> Void) {
        
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
                
                self.constructURL(id: photoDictionary["id"] as? String, server: photoDictionary["server"] as? String, farm: photoDictionary["farm"] as? Int, secret: photoDictionary["secret"] as? String)
            }
            
        } catch {
            print("Error with JSON data")
        }
        
        completionHandler(nil, true, nil)
        
    } // End jsonParser
    
    // MARK: create the URL for the photos
    func constructURL(id: String?, server: String?, farm: Int?, secret: String?) {
        
        // optional binding to unwrap optionals from parameters
        if let id = id, let server = server, let farm = farm, let secret = secret {
            let photoURL = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
            photoURLArray.append(photoURL)
            //print("Photo URL appended: ", photoURL)
        } else {
            print("Unable to construct URL for photos.")
        }
        
    } // end construcURL
    
    func downloadPhotos(completionHandler: @escaping () -> Void) {
        
        var counter = 0
        let session  = URLSession.shared
        
        while counter < FlickrClient.sharedInstance().photoURLArray.count {
            
            let photoURL = FlickrClient.sharedInstance().photoURLArray[counter]
            
            let request = URLRequest(url: URL(string: photoURL)!)
            
            let task = session.dataTask(with: request) { data, response, error in
                
                print("Sent request to Flickr server... waiting on data.")
                
                guard (error == nil) else {
                    print("Error retrieving photos from Flickr.")
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("Error retrieving photos from Flickr - HTTP response")
                    return
                }
                
                guard (data != nil) else {
                    print("There was an error - no data")
                    return
                }
                
                self.imageArray.append(UIImage(data: data!)!)
                print("New image added to list")
            }
            counter += 1
            task.resume()
        } // end of while loop
        
        completionHandler()
    } // End downloadPhotos()

    // MARK: Singleton pattern for a shared FlickrClient instance across the app
    class func sharedInstance() -> FlickrClient {
        struct FlickrSingleton {
            static var sharedFlickrClientInstance = FlickrClient()
        }
        
        return FlickrSingleton.sharedFlickrClientInstance
    } // End sharedInstance()
    
} // End FlickrClient
