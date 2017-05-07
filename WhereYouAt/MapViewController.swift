//
//  MapViewController.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 4/17/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import MapKit
import Parse
import ParseUI

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var locationManager: CLLocationManager!
    var address: String? // in prev segue way thing
    var coordinate: CLLocationCoordinate2D?
    var addedAnnotation: [MKPointAnnotation]!
    var events: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        addedAnnotation = [MKPointAnnotation]()
        
        var uilgr = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(_:)))
        uilgr.minimumPressDuration = 2.0
        
        mapView.addGestureRecognizer(uilgr)
        
        //IOS 9
        mapView.addGestureRecognizer(uilgr)
        
    }
    
    func addAnnotation(_ sender:UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began {
            var touchPoint = sender.location(in: mapView)
            var newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    if let pm = placemarks?[0] {
                        annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
                        annotation.subtitle = pm.subLocality
                        self.mapView.addAnnotation(annotation)
                        print(pm)
                    }
                    else {
                        annotation.title = "Unknown Place"
                        self.mapView.addAnnotation(annotation)
                        print("Problem with the data received from geocoder")
                    }
                }
                else {
                    annotation.title = "Unknown Place"
                    self.mapView.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
                //places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
            })
        }
    }
    
   /* func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
        }
        
        let leftView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        annotationView?.leftCalloutAccessoryView = leftView
        annotationView?.canShowCallout = true
        
        
        // Add the image you stored from the image picker
        
        
        return annotationView
    }
    
    @IBAction func tapToAddPin(_ sender: UILongPressGestureRecognizer) {
        longPressGestureRecognizer.delegate = self
        
        /* Convert the tapped location in map to coordinate */
        let location = sender.location(in: mapView)
        let coordinate = self.mapView.convert(location, to: mapView)
        let convertedCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(coordinate.x), CLLocationDegrees(coordinate.y))
        
        /* Add annotation pin to map */
        let annotation = MKPointAnnotation()
        annotation.title = "Bob"
        annotation.coordinate = convertedCoordinate
        self.mapView.addAnnotation(annotation)
        addedAnnotation.append(annotation)
        print("Tap area: \(coordinate)")
    }
    
}
