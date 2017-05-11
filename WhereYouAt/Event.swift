//
//  Event.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 5/10/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class Event: PFObject {
    var event: String?
    var author: String?
    var eventDescription: String?
    var attendees: [String]?
    var location: String?
    
}
