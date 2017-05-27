//
//  AttendeesCell.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/7/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import AFNetworking

class AttendeesCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    var userId : String! {
        didSet {
            var user : PFObject?
            let query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: userId)
            
            query.findObjectsInBackground { (results, error) in
                if let results = results {
                    user = results[0]
                    
                    print(user?.description)
                    
                    //self.profileImage.file = user?["profilePic"] as? PFFile
                    self.userNameLabel.text = user?["username"] as? String
                    
                    if let image = user?["profilePic"] as? PFFile {
                        image.getDataInBackground(block: { (imageData, error) in
                            if let imageData = imageData {
                                let image = UIImage(data: imageData)
                                self.profileImage.image = image
                            }
                        })
                    }
                    else {
                        let profile = #imageLiteral(resourceName: "iconmonstr-user-6-240")
                        self.profileImage.image = profile
                    }
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
