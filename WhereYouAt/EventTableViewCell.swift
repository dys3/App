//
//  EventTableViewCell.swift
//  WhereYouAt
//
//  Created by SongYuda on 4/23/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AFNetworking

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var numberAttendeeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    
    var event : PFObject! {
       didSet {
        if let image = event["imageFile"] as? PFFile {
            print((event["imageFile"] as AnyObject).description)
            image.getDataInBackground(block: { (imageData, error) in
                if let imageData = imageData {
                    self.eventImage.image = UIImage(data: imageData)
                }
            })
            
            
        }
        if let name = event["name"] as? String {
            self.eventNameLabel.text = name
        }
        
        if let location = event["location"] as? String {
            self.locationLabel.text = location
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss"

        if let postedTime = event.createdAt  {
            
            let timeDiff = (Int)(Date().timeIntervalSince(postedTime))
            
            if(timeDiff < 60 ) {
                timePostedLabel.text = "\(timeDiff)s"
            }
            else if(timeDiff < 3600) {
                timePostedLabel.text = "\(timeDiff/60)m"
            }
            else if(timeDiff < 86400) {
                timePostedLabel.text = "\(timeDiff/3600)h"
            }
            else {
                timePostedLabel.text = "\(timeDiff/86400)d"
            }
        }
        
        if let eventTime = event["event_time"] as? Date {
            self.eventTimeLabel.text = dateFormatter.string(from: eventTime)
        }

        if let attendees = event["attendees"] as? [String] {
            self.numberAttendeeLabel.text = attendees.count.description
        }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
