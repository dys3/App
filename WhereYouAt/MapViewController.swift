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

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var address: String? // in prev segue way thing
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
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
    
    func locationsPickedLocation(/*controller: LocationsViewController,*/ latitude: NSNumber, longitude: NSNumber) {
        addPin(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
        }
        
        let leftView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
//        leftView.image = pickedImage
        annotationView?.leftCalloutAccessoryView = leftView
        annotationView?.canShowCallout = true
        
        
        // Add the image you stored from the image picker
        
        return annotationView
    }
    
    func onTap(gestureRecognizer: UITapGestureRecognizer) {
        print("tap!")

        let location = gestureRecognizer.location(in: mapView)
        let coordinate = self.view.convert(location, to: mapView)
        
        print("Tap area: \(coordinate)")
        
        // Add anotation
        /*
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate as! CLLocationCoordinate2D
        mapView.addAnnotation(annotation)
 */
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinate
//        self.view.add(annotation)
    }
    
    @IBAction func tapToAddPin(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = self.mapView.convert(location, to: mapView)
        let convertedCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(coordinate.x), CLLocationDegrees(coordinate.y))
        
        let annotation = MKPointAnnotation()
        annotation.title = "Bob"
        annotation.coordinate = convertedCoordinate
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
        print("Tap area: \(coordinate)")
    }
    
    
    func addPin(latitude: NSNumber, longitude: NSNumber) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        annotation.coordinate = locationCoordinate
        annotation.title = "D.N.E."
        mapView.addAnnotation(annotation)
    }
}
