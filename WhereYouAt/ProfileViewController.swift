//
//  ProfileViewController.swift
//  WhereYouAt
//
//  Created by Richard Du on 4/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    var user: User! {
        didSet {
            
            
        }
    }
    
    if let profilePic = object.valueForKey("Image")! as! PFFile {
        userPicture.getDataInBackground({ (imageData: Data?, error: Error?) -> Void in
            let image = UIImage(data: imageData!)
            if image != nil {
                self.imageArray.append(image!)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogout(_ sender: AnyObject) {
       
        PFUser.logOutInBackground { (error:Error?) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"UserDidLogout"), object: nil)
            
            print("Logging out")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
