//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-22.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController : UIViewController, UINavigationControllerDelegate, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    var pinnedLocations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Virtual Tourist"
        mapView.delegate = self

    } // End viewDidLoad()
    
    
    @IBAction func longPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            self.becomeFirstResponder()
            
            let pinnedLocation = MKPointAnnotation()
            let point = sender.location(in: mapView)
            let coordinates = mapView.convert(point, toCoordinateFrom: mapView)
            pinnedLocation.coordinate = coordinates
            
            pinnedLocations.append(pinnedLocation)
            
            self.updateMapWithNewPin(locations: pinnedLocations)
        }
    } // End longPressGesture()
    
    func updateMapWithNewPin(locations : [MKPointAnnotation]) {
        
        for pinLocation in pinnedLocations {
            mapView.addAnnotation(pinLocation)
        }
        
    } // End updateMapWithNewPin()
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.pinTintColor = .red
            pinView?.animatesDrop = true
        } else {
            pinView?.annotation = annotation
        }
        
        let lat = pinView?.annotation?.coordinate.latitude.description
        let lon = pinView?.annotation?.coordinate.longitude.description
        
        FlickrClient.sharedInstance().getPinLocation(lat: lat!, lon: lon!)
        FlickrClient.sharedInstance().getPhotos()
        
        return pinView
    } // End mapView()
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        self.mapView.deselectAnnotation(view.annotation, animated: true)
        
        print("Image count: ", FlickrClient.sharedInstance().imageArray.count)
        
        let photoAlbumVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoAlbumViewController") as! PhotoAlbumViewController
        self.navigationController?.pushViewController(photoAlbumVC, animated: true)
        
    } // End mapView()
    
} // End TravelLocationsMapViewController
