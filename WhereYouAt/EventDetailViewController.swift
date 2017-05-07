//
//  EventDetailViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MapKit

class EventDetailViewController: UIViewController {

    
    @IBOutlet weak var overViewLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    
    // event is passed from segue
    var event : PFObject! {
        didSet {
            
            
            // set up name label
            if let name = event["name"] as? String {
                eventNameLabel.text = name;
            }
            
            // set up date label
            if let date = event["event_date"] as? Date {
            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                eventTimeLabel.text = dateFormatter.string(from: date)
            }
            
            // set up address label
            let address = event["location"] as? String

            if let address = address {
                addressLabel.text = address
                
                // also center the map at the address
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address , completionHandler: { (placemarks, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        if placemarks?.count != 0 {
                            let coordinate = placemarks?.first!.location!
                            self.eventMap.setCenter((coordinate?.coordinate)!, animated: false)
                            
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapAttendees(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "toAttendeesList", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let attendeesVC = segue.destination as? AttendeesViewController {
            
            if let attendees = self.event["attendees"] as? [String]{
                attendeesVC.attendees = attendees
            }
        }
        
    }
    

}
