//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Adam DeCaria on 2017-08-22.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapViewController : UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pinnedLocations = [MKPointAnnotation]()

    override func viewDidLoad() {
        mapView.delegate = self
    } // End viewDidLoad()
    
    @IBAction func longPressPlacePin(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            self.becomeFirstResponder()
            
            let pinnedLocation = MKPointAnnotation()
            let point = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(point, toCoordinateFrom: mapView)
            pinnedLocation.coordinate = coordinates
            
            pinnedLocations.append(pinnedLocation)
            
            self.updateMapWithNewPin(locations: pinnedLocations)
        }
        
    } // End longPressPlacePin()
    
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
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.animatesDrop = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    } // End mapView()
    
} // End TravelLocationsMapViewController
