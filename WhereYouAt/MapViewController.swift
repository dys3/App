//
//  MapViewController.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 4/17/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation
import MapKit
import Parse
import ParseUI

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, EventDetailViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var locationManager: CLLocationManager!
    var address: String? // in prev segue way thing
    var coordinate: CLLocationCoordinate2D?
    var addedAnnotation: [MKPointAnnotation]!
    var events: [PFObject]?
    
    var isPassedInFromEventDetailedViewController = false
    
    var userPressAnnotation:MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        print("load")
        if isPassedInFromEventDetailedViewController {
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: self.coordinate!, span: mapSpan)
            self.mapView.setRegion(region, animated: false)
        }
        else {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        addedAnnotation = [MKPointAnnotation]()
        userPressAnnotation = MKPointAnnotation()
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(_:)))
        uilgr.minimumPressDuration = 2.0
        
        mapView.addGestureRecognizer(uilgr)
        
        //IOS 9
        mapView.addGestureRecognizer(uilgr)
        //l
        }
        isPassedInFromEventDetailedViewController = false
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mapView.delegate = self
        print("appear")
        if isPassedInFromEventDetailedViewController {
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: self.coordinate!, span: mapSpan)
            self.mapView.setRegion(region, animated: false)
        }
        else {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 200
            locationManager.requestWhenInUseAuthorization()
            
            addedAnnotation = [MKPointAnnotation]()
            userPressAnnotation = MKPointAnnotation()
            let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(_:)))
            uilgr.minimumPressDuration = 2.0
            
            mapView.addGestureRecognizer(uilgr)
            
            //IOS 9
            mapView.addGestureRecognizer(uilgr)
            //l
        }
        isPassedInFromEventDetailedViewController = false
        
        let query = PFQuery(className: "_User")
        query.findObjectsInBackground { (results:[PFObject]?, error:Error?) in
            if let error = error{
                print(error.localizedDescription)
            }
            else {
                //print(results)
                for user in results! {
                    if let lat = user["latitude"]{
                        
                        if PFUser.current()!.objectId != user.objectId {
                            
                            let userAnnotation = MKPointAnnotation()
                            let userLat = user["latitude"] as! CLLocationDegrees
                            let userLong = user["longitude"] as! CLLocationDegrees
                            let userCoord = CLLocationCoordinate2D(latitude: userLat,  longitude: userLong)
                    
                            userAnnotation.coordinate = userCoord
                            self.mapView.addAnnotation(userAnnotation)
                            userAnnotation.title = user["screen_name"] as! String
                        }
                    }
                }
            }
        }
    }
    
    func addAnnotation(_ sender:UIGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began {
            let touchPoint = sender.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            //let annotation = MKPointAnnotation()
            
            //annotation = MKPointAnnotation()
            userPressAnnotation.coordinate = newCoordinates
            
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if let placemarks = placemarks, let placemark = placemarks.first,
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    let thoroughfare = placemark.thoroughfare, let subThoroughfare = placemark.subThoroughfare {
                        self.userPressAnnotation.title = thoroughfare + ", " + subThoroughfare
                        self.userPressAnnotation.subtitle = placemark.subLocality
                        self.mapView.addAnnotation(self.userPressAnnotation)
                        print(placemark)
                    
                }
                else {
                    self.userPressAnnotation.title = "Unknown Place"
                    self.mapView.addAnnotation(self.userPressAnnotation)
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // LocationManager functions for finding current user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdatelocations")
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            print("location: \(location)")
            let currentUser = PFUser.current()
            if currentUser != nil {
                currentUser!["longitude"] = location.coordinate.longitude
                currentUser!["latitude"] = location.coordinate.latitude
            
                currentUser!.saveInBackground(block: { (success:Bool, error: Error?) in
                    print("SavedCurrentLocation")
                })
            }
            
            mapView.setRegion(region, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        print("AGBCDEFG")
        /*var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
        }
         
        
        let leftView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        annotationView?.leftCalloutAccessoryView = leftView
        annotationView?.canShowCallout = true
        
        */
        // Add the image you stored from the image picker
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        print(annotation.description.description.description)
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //pinView!.animatesDrop = false
            pinView!.image = #imageLiteral(resourceName: "iconmonstr-location-3-240")
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
        
        //return annotationView
    }
    /*
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
    }*/
    
    func locationTapedMap(controller: EventDetailsViewController, lat: NSNumber, lng: NSNumber, event: PFObject) {
        self.events?.append(event)
        self.coordinate = CLLocationCoordinate2D(latitude: lat as CLLocationDegrees, longitude: lng as CLLocationDegrees)
        print("here at the bottom")
        self.isPassedInFromEventDetailedViewController = true
    }
    
}
