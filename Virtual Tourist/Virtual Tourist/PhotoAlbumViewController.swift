//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-22.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController : UIViewController, UINavigationControllerDelegate, MKMapViewDelegate {
    
    override func viewDidLoad() {
        self.navigationItem.title = "Virtual Tourist"
        
        FlickrClient.sharedInstance().getPhotos( completionHandler: { (results, success, error) in
            
            if success {
                print("Success!")
            } else {
                print("Error")
            }
            
        })
    }
    
} // End PhotoAlbumViewController
