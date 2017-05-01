//
//  Message.swift
//  WhereYouAt
//
//  Created by SongYuda on 4/30/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit

class Message: NSObject {

    var senderID : String?
    var receiverID : String?
    var updateTime : Date?
    var content : String?
    
    init(message: String) {
        content = message
    }
    
}
