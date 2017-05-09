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
    let UserQuery = PFQuery("User")
    let ChatMessageQuery = PFQuery("ChatMessage")
    let EventQuery = PFQuery("Event")
    
    func retrieveAttendees() {
        
    }
    
    func retrieveEvents() {
        
    }
    
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
