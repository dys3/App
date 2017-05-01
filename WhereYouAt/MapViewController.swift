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

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var locationManager: CLLocationManager!
    var address: String? // in prev segue way thing
    var coordinate: CLLocationCoordinate2D?
    var addedAnnotation = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //mapView.delegate = self
        
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
        
        let location = sender.location(in: mapView)
        let coordinate = self.mapView.convert(location, to: mapView)
        let convertedCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(coordinate.x), CLLocationDegrees(coordinate.y))
        
        let annotation = MKPointAnnotation()
        annotation.title = "Bob"
        annotation.coordinate = convertedCoordinate
        self.mapView.addAnnotation(annotation)
        addedAnnotation.append(annotation)
        print("Tap area: \(coordinate)")
    }
    
}
