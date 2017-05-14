//
//  NewEventViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

protocol NewEventViewControllerDelegate: class {
    func afterPost(controller: NewEventViewController)
}

class NewEventViewController: UIViewController, LocationsViewControllerDelegate, addAttendeesViewControllerDelegate {
    
    weak var delegate : NewEventViewControllerDelegate!

    @IBOutlet weak var attendeesTextFiled: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var addedAttendees : [PFObject]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var langitude: NSNumber!
    var longitude: NSNumber!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickChoose(_ sender: Any) {
        self.performSegue(withIdentifier: "addLocation" , sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
        }
        
        if segue.identifier == "addAttendees" {
            let addVC = segue.destination as! addAttendeesViewController
            addVC.delegate = self
        }
    }
    
    @IBAction func onClickChooseUser(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addAttendees", sender: nil)
    }
    
    func locationsPickedLocation(controller: LocationsViewController, address: String, lat: NSNumber, lng: NSNumber) {
        addressTextField.text = address
        langitude = lat
        longitude = lng
    }
    
    func pickedUser(controller: addAttendeesViewController, user: PFObject) {
        
        print(user.description)
        var username : [String]? = []
        addedAttendees!.append(user)
        for addedAttendee in addedAttendees! {
                username?.append(addedAttendee["username"] as! String)
        }
        
        
        attendeesTextFiled.text = username?.description
    }

  
    @IBAction func onClickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickedPost(_ sender: Any) {
        let event = PFObject(className: "Event")
        if let username = PFUser.current()?["username"]{
            event["author"] = username
        }
        else {
            print("no username")
        }
        
        event["location"] = self.addressTextField.text
        
        if let id = PFUser.current()?.objectId {
            event.add(id, forKey: "attendees")
        }
        else {
            print("no user id")
        }
        
        event["description"] = self.descriptionTextField.text
        
        event["event_time"] = self.datePicker.date
        
        event["name"] = self.nameTextField.text
        
        event["latitude"] = self.langitude
        event["longitude"] = self.longitude
        
        print(self.addedAttendees?.description)
        
        if let attendees = self.addedAttendees {
            for attendee in attendees {
                event.add(attendee.objectId!, forKey: "attendees")
            }
        }
        
        event.saveInBackground { (success, error) in
            if success {
                print("saved")
                self.delegate.afterPost(controller: self)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }


}
