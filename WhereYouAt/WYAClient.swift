//
//  WYAClient.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 5/8/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class WYAClient: Parse {
    static let UserQuery = PFQuery(className: "User")
    static let ChatMessageQuery = PFQuery(className: "ChatMessage")
    static var EventQuery = PFQuery(className: "Event")
    
    static func retrieveAttendees(event: Event) -> [PFObject] {
        var attendees: [PFObject]!
                
        EventQuery.whereKey("name", equalTo: event)
        EventQuery.findObjectsInBackground { (participants, error) in
            if let participants = participants {
                for participant in participants {
                    attendees.append(participant)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        return attendees
    }
    
    static func retrieveEvents() -> [PFObject] {
        var returnEvents: [PFObject]!
        
        EventQuery.order(byDescending: "createdAt")
        EventQuery.findObjectsInBackground { (events, error) in
            if let events = events {
                for event in events {
                    returnEvents.append(event)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        return returnEvents
    }
    
    
    func createUser() {
        
    }
    
    func newUser() {
        
    }
    
    /*
    static func login(username:String!, password:String!, completion: @escaping ()->(user: PFUser?, error: Error?)) {
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error:Error?) in
            completion(user, error)
            
            if user != nil {
                print("You're logged in")
                
                completion(user, error)
                //self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
    }*/
    
//    UserQuery.findObjectsInBackground { (events, error) in
//    if let events = events {
//    self.events = events
//    self.tableView.reloadData()
//    }
//    else {
//    print(error?.localizedDescription)
//    }
//    }
    
}
