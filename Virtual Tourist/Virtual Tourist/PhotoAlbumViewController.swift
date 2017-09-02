//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-22.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController : UIViewController, UINavigationControllerDelegate, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Virtual Tourist"
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.downloadPhotos()
        }

    } // End viewDidLoad()
    
    @IBAction func newCollectionButtonTapped(_ sender: Any) {
        
    } // End newCollectionButtonTapped
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Collection view count: ", FlickrClient.sharedInstance().photoURLArray.count)
        return FlickrClient.sharedInstance().photoURLArray.count
    } // End collectionView()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        let photo = imageArray[(indexPath as NSIndexPath).row]
        cell.flickrPhoto.image = photo
        
        return cell
    } // End collectionView()
    
    func downloadPhotos() {
    
        var counter = 0
        let session  = URLSession.shared
        
        while counter < FlickrClient.sharedInstance().photoURLArray.count {
            
            var photoURL = FlickrClient.sharedInstance().photoURLArray[counter]
            //print("Count is: ", counter)
            
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
                //print("New image added to list")
            }
            counter += 1
            task.resume()
        }

    } // End downloadPhotos()
    
} // End PhotoAlbumViewController
