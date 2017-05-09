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

class NewEventViewController: UIViewController, LocationsViewControllerDelegate {
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
    }
    
    func locationsPickedLocation(controller: LocationsViewController, address: String) {
        addressTextField.text = address
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
        
        event.saveInBackground { (success, error) in
            if success {
                print("saved")
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }


}
