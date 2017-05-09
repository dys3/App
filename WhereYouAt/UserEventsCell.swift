//
//  UserEventsCell.swift
//  WhereYouAt
//
//  Created by Ulric Ye on 5/8/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse

class UserEventsCell: UITableViewCell {

    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
