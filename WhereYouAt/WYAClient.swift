//
//  WYAClient.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 5/8/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import Foundation
import Parse

class WYAClient {
    let UserQuery = PFQuery(className: "User")
    let ChatMessageQuery = PFQuery(className: "ChatMessage")
    let EventQuery = PFQuery(className: "Event")
    
    func retrieveAttendees(event: Event) -> [String] {
        
    }
    
    func retrieveEvents() {
        
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
