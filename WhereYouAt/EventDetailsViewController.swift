//
//  EventDetailsViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import MapKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var eventTimeLable: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    // event is passed from segue
    var event : PFObject!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(event.description)
        // set up name label
        if event["name"] != nil {
            if eventNameLabel == nil {
                print("nil")
            }
            self.eventNameLabel.text = event["name"] as? String
        }
        
        // set up date label
        if let date = event["event_time"] as? Date {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss"
            self.eventTimeLable.text = dateFormatter.string(from: date)
        }
        
        // set up address label
        let address = event["location"] as? String
        
        if let address = address {
            addressLabel.text = address
        }
        
        if let lat = event["latitude"], let lng = event["longitude"] {
            let mapCenter = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
            self.eventMap.setRegion(region, animated: false)
            
            // add annotation to the map
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapCenter
            if let name = self.event["name"] as? String {
                annotation.title = name
            }
            else {
                annotation.title = address
            }
            self.eventMap.addAnnotation(annotation)
        }
            
        else if let address = address {
            // also center the map at the address
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if placemarks?.count != 0 {
                        let coordinate = placemarks?.first!.location!
                        
                        
                        let mapCenter = (coordinate?.coordinate)!
                        
                        print((coordinate?.coordinate)!)
                        
                        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
                        
                        self.eventMap.setRegion(region, animated: false)
                        
                        // add annotation to the map
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = (coordinate?.coordinate)!
                        if let name = self.event["name"] as? String {
                            annotation.title = name
                        }
                        else {
                            annotation.title = address
                        }
                        self.eventMap.addAnnotation(annotation)
                    }
                }
            })
        }
        
        // set up overview label
        if let overview = event["description"] as? String {
            overViewLabel.text = overview
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onTapAttendees(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showAttendees", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let attendeesVC = segue.destination as? AttendeesViewController {
            
            if let attendees = self.event["attendees"] as? [String]{
                attendeesVC.attendees = attendees
            }
        }
        
    }
    
    
}

