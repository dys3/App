//
//  EventDetailsViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

protocol EventDetailViewControllerDelegate: class {
    func locationTapedMap(controller: EventDetailsViewController, lat: NSNumber, lng: NSNumber, event: PFObject)
}

import UIKit
import Parse
import MapKit



class EventDetailsViewController: UIViewController {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var eventTimeLable: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var creatorImage: UIImageView!
    
    @IBOutlet weak var creatorNameLable: UILabel!
    // event is passed from segue
    var event : PFObject!
    var address: String?
    var coordinate: CLLocationCoordinate2D?
    var lat: NSNumber?
    var lng: NSNumber?
    
    weak var delegate : EventDetailViewControllerDelegate!
 
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
            dateFormatter.dateFormat = "MMMd"
            self.dateLabel.text = dateFormatter.string(from: date)
             dateFormatter.dateFormat = "HH:mm"
            self.eventTimeLable.text = dateFormatter.string(from: date)
            
        }
        
        // set up address label
        let address = event["location"] as? String
        
        if let address = address {
            self.address = address
            addressLabel.text = address
        }
        
        if let lat = event["latitude"], let lng = event["longitude"] {
            self.lat = lat as! NSNumber
            self.lng = lng as! NSNumber
            let mapCenter = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees)
            self.coordinate = mapCenter
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
        
        if let attendees = event["attendees"] as? [String] {
            let userId = attendees[attendees.count-1]
            print(userId)
            var user : PFObject?
            let query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: userId)
            
            query.findObjectsInBackground { (results, error) in
                if let results = results {
                    user = results[0]
                    print(user?.description)
                    if let name = user?["username"] as? String {
                        self.creatorNameLable.text = name
                    }
                    if let image = user?["profilePic"] as? PFFile {
                        image.getDataInBackground(block: { (imageData, error) in
                            if let imageData = imageData {
                                let image = UIImage(data: imageData)
                                self.creatorImage.image = image
                            }
                        })
                    }
                    else {
                        let profile = #imageLiteral(resourceName: "iconmonstr-user-1-240")
                        self.creatorImage.image = profile
                    }

                    
                }
            }

        }
        
        if let image = event["imageFile"] as? PFFile {
            image.getDataInBackground(block: { (imageData, error) in
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    self.backgroundImage.image = image
                    self.backgroundImage.contentMode = UIViewContentMode.scaleToFill
                }
            })
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
    
    @IBAction func onTapMap(_ sender: UITapGestureRecognizer) {
        if let lat = self.lat, let lng = self.lng {
            let NC = tabBarController?.viewControllers?[2] as! UINavigationController
            
            delegate = NC.topViewController as! EventDetailViewControllerDelegate
            delegate.locationTapedMap(controller: self, lat: lat, lng: lng, event: self.event)
            tabBarController?.selectedIndex = 2
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showAttendees" {
        if let attendeesVC = segue.destination as? AttendeesViewController {
            
            if let attendees = self.event["attendees"]{
                attendeesVC.attendees = attendees as! [String]
            }
        }
        }
        
        if segue.identifier == "toMap" {
            print(segue.destination.description)
        }
        
    }
    
    
}

