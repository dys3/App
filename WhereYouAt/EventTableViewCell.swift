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

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var numberAttendeeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var eventImage: PFImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    var event : PFObject! {
       didSet {
            self.eventImage.file = event["imageFile"] as? PFFile
            self.eventNameLabel.text = event["name"] as? String
            self.timePostedLabel.text = event["createdAt"] as? String
            self.locationLabel.text = event["location"] as? String
            self.numberAttendeeLabel.text = event["attendees"] as? String
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
