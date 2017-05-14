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
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //let user = PFObject(className: "User")
        let user = PFUser.current()
        
        if let profileImageFile = user?["profileImage"] as? PFFile {
            profileImageFile.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error != nil {
                    self.profilePic.image = UIImage(data:imageData!)
                }
            }
        } else {
            profilePic.image = UIImage(named: "dummy_user")
            
        }
        
        if let screenName = user?["screen_name"] as? String {
            self.screenName.text = screenName
        }
        
        if let firstName = user?["first_name"] as? String {
            self.firstName.text = firstName
        }
        
        if let lastName = user?["last_name"] as? String {
            self.lastName.text = lastName
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
    
    
    @IBAction func onClickSearch(_ sender: Any) {
        self.performSegue(withIdentifier: "search", sender: nil)
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
<<<<<<< HEAD
/*
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}*/
=======
//
//extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}
>>>>>>> master

