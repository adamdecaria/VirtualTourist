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
    
    override func viewDidLoad() {
      
        self.navigationItem.title = "Virtual Tourist"
    } // End viewDidLoad()
    
    @IBAction func newCollectionButtonTapped(_ sender: Any) {
 
    } // End newCollectionButtonTapped
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return FlickrClient.sharedInstance().photoURLArray.count
    } // End collectionView()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoAlbumCollectionViewCell
        
        DispatchQueue.main.async {
            cell.activityViewIndicator.startAnimating()
        }
        
        let photo = FlickrClient.sharedInstance().downloadPhoto(photoURL: FlickrClient.sharedInstance().photoURLArray[(indexPath as NSIndexPath).row])
        cell.flickrPhoto.image = photo
        
        return cell
    } // End collectionView()
    
} // End PhotoAlbumViewController
