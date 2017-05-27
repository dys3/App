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

class CustomPointAnnotation: MKPointAnnotation {
    var pinType: String!
}

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, EventDetailViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var locationManager: CLLocationManager!
    var address: String? // in prev segue way thing
    var coordinate: CLLocationCoordinate2D?
    var addedAnnotation: [MKPointAnnotation]!
    var events: [PFObject]?
    var attendees: [String]?
    
    var isPassedInFromEventDetailedViewController = false
    
    var eventAnnotation: CustomPointAnnotation!
    var userPressAnnotation:MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        print("load")
        if eventAnnotation == nil {
            eventAnnotation = CustomPointAnnotation()
            print("event annotation is nil1")
        }
        if isPassedInFromEventDetailedViewController {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 200
            locationManager.requestWhenInUseAuthorization()
            
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: self.coordinate!, span: mapSpan)
            self.mapView.setRegion(region, animated: false)
            
            self.mapView.addAnnotation(eventAnnotation)
            print("addedEventAnnotation1")
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
        //isPassedInFromEventDetailedViewController = false
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        mapView.delegate = self
        print("appear")
        if eventAnnotation == nil {
            eventAnnotation = CustomPointAnnotation()
            print("event annotation is nil2")
        }
        
        if isPassedInFromEventDetailedViewController {
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 200
            locationManager.requestWhenInUseAuthorization()
            
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: self.coordinate!, span: mapSpan)
            self.mapView.setRegion(region, animated: false)
            self.mapView.addAnnotation(eventAnnotation)
            print("addedEventAnnotation2")
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
        /*
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
                            
                            let userAnnotation = CustomPointAnnotation()
                            let userLat = user["latitude"] as! CLLocationDegrees
                            let userLong = user["longitude"] as! CLLocationDegrees
                            let userCoord = CLLocationCoordinate2D(latitude: userLat,  longitude: userLong)
                    
                            userAnnotation.coordinate = userCoord
                            userAnnotation.pinType = "user"
                            userAnnotation.title = user["screen_name"] as! String
                            
                            
                            self.mapView.addAnnotation(userAnnotation)
                            
                        }
                    }
                }
            }
        }*/
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
            if eventAnnotation != nil {
                self.mapView.addAnnotation(eventAnnotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        // Add the image you stored from the image picker
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            
        }
        else {
            pinView!.annotation = annotation
        }
        

        if let pointAnnotation = annotation as? CustomPointAnnotation {

            if pointAnnotation.pinType == "event" {
                pinView!.image = #imageLiteral(resourceName: "iconmonstr-location-3-240")
            }
            else if pointAnnotation.pinType == "user" {
                pinView!.image = #imageLiteral(resourceName: "iconmonstr-user-20-32")
            }
        }

        return pinView
    }
    
    func locationTapedMap(controller: EventDetailsViewController, lat: NSNumber, lng: NSNumber, event: PFObject) {
        self.isPassedInFromEventDetailedViewController = true
        self.events?.append(event)
        self.coordinate = CLLocationCoordinate2D(latitude: lat as CLLocationDegrees, longitude: lng as CLLocationDegrees)
        print("here at the bottom")
        if eventAnnotation == nil {
            eventAnnotation = CustomPointAnnotation()
            print("event annotation is nil3")
        }
        eventAnnotation.pinType = "event"
        eventAnnotation.coordinate = self.coordinate!
        eventAnnotation.title = event["name"] as! String
        attendees = event["attendees"] as! [String]?
        
        print(eventAnnotation.coordinate)
        let query = PFQuery(className: "_User")
        
        query.whereKey("objectId", containedIn: attendees!)
        
        query.findObjectsInBackground { (users, error) in
            
            if self.mapView != nil {
                
                for _annotation in self.mapView.annotations {
                    if let annotation = _annotation as? MKAnnotation
                    {
                        self.mapView.removeAnnotation(annotation)
                    }
                }
            }
            for user in users! {
                print(user)
                
                if let lat = user["latitude"]{
                    
                    if PFUser.current()!.objectId != user.objectId {
                    
                        let userAnnotation = CustomPointAnnotation()
                        let userLat = user["latitude"] as! CLLocationDegrees
                        let userLong = user["longitude"] as! CLLocationDegrees
                        print("userLat:\(userLat)")
                        print("userLong:\(userLong)")
                        let userCoord = CLLocationCoordinate2D(latitude: userLat,  longitude: userLong)
                    
                        userAnnotation.coordinate = userCoord
                        userAnnotation.pinType = "user"
                        userAnnotation.title = user["screen_name"] as! String
                    
                    
                        self.mapView.addAnnotation(userAnnotation)
                    
                    }
                }
            }
        }
    }
    
}
