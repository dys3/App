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
    
    var user: User!
    var profilePic: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let user = PFObject(className: "User")
        if let profileImageFile = user["profileImage"] as? PFFile {
            if profileImageFile == nil {
                profilePic = UIImage(named: "dummy_user")
            } else {
                profileImageFile.getDataInBackground {
                    (imageData: Data?, error: Error?) -> Void in
                    if error != nil {
                        self.profilePic = UIImage(data:imageData!)
                    }
                }
            }
        }

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
