//
//  AttendeesCell.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AttendeesCell: UITableViewCell {
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    var userId : String! {
        didSet {
            var user : PFObject?
            let query = PFQuery(className: "User")
            query.whereKey("objectId", equalTo: userId)
            
            query.findObjectsInBackground { (results, error) in
                if let results = results {
                    user = results[0]
                    self.profileImage.file = user?["profilePic"] as? PFFile
                    self.userNameLabel.text = user?["username"] as? String
                }
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
