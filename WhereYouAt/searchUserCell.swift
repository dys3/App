//
//  searchUserCell.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/9/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class searchUserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user : PFObject! {
        didSet {
            usernameLabel.text = user["username"] as? String
            
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
            
            let radius = profileImage.frame.width / 2
            profileImage.layer.cornerRadius = radius
            profileImage.layer.masksToBounds = true
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
