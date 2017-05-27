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
    @IBOutlet weak var tableView: UITableView!
    
    var events = [PFObject]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //let user = PFObject(className: "User")
        let user = PFUser.current()
        /*tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        */
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
        
        //fetchData()
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


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserEventsCell") as! UserEventsCell
        cell.eventTitleLabel.text = events[indexPath.row]["name"] as! String?
        cell.eventDescriptionLabel.text = events[indexPath.row]["description"] as! String?
        
        return cell
        
    }
    
    func fetchData() {
        let query = PFQuery(className: "Event")
        
        query.order(byDescending: "createdAt")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (events, error) in
            if let events = events {
                self.events = events
                self.tableView.reloadData()
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }
    
}


