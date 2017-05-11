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
    
    func retrieveAttendees(event: Event) -> [PFObject] {
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
    
    func retrieveEvents() -> [PFObject] {
        var returnEvents: [PFObject]!
        
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
