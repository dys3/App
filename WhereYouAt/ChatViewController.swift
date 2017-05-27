//
//  ChatViewController.swift
//  WhereYouAt
//
//  Created by Richard Du on 4/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//
import UIKit
import Parse
import ParseUI


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userID : String = ""
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages : [PFObject]!
    var users: [PFObject]!
    
    var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        messageTextField.placeholder = "Message..."
        
        //fetching()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickSend(_ sender: Any) {
        if messageTextField.text != "" {
            let messageToSend = Message(message: messageTextField.text!)
            var parseMessage = PFObject(className: "ChatMessage")
            parseMessage["Text"] = messageToSend.content
            parseMessage["sender_user_id"] = PFUser.current()?.objectId
            parseMessage["sender_username"] = PFUser.current()?.username
            parseMessage["profilePic"] = PFUser.current()?["profilePic"]
            parseMessage["receiver_user_id"] = userID
            parseMessage.saveInBackground { (success: Bool, error: Error?) in
                if(success) {
                    print("saved")
                    self.messageTextField.text = ""
                    
                } else {
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        if let message = messages[indexPath.row]["Text"] as? String {
            cell.messageText.text = message
        }
        if let username = messages[indexPath.row]["sender_username"] as? String {
            cell.userLabel.text = username
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM d HH:mm"
        
        if let time = messages[indexPath.row].createdAt {
            let timeDiff = (Int)(Date().timeIntervalSince(time))
            cell.timeLabel.text = self.timeSinceString(time: timeDiff)
        }
        
        if let userPic = self.messages[indexPath.row]["profilePic"] as? PFFile {
            userPic.getDataInBackground(block: { (imageData, error) in
                if let imageData = imageData {
                    cell.profileImage.image = UIImage(data: imageData)
                } else {
                    let profile = #imageLiteral(resourceName: "profile-icon")
                    cell.profileImage.image = profile
                }
            })
        }
        
        //cell.userLabel.text = user["username"] as! String
        return cell
    }
    
    func onTimer() {
        if !isFetching {
            self.isFetching = true
            var query = PFQuery(className: "ChatMessage")
            query.order(byDescending: "createdAt")
            // getting messages that sent from current user
            //query.whereKey("sender_user_id", equalTo: PFUser.current()?["userId"] as! String)
            
            query.findObjectsInBackground(block: { (results:[PFObject]?, error:Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    for result in results! {
                        self.messages = results
                        self.isFetching = false
                        self.tableView.reloadData()
                    }
                }
            })
            
            //            // getting messages that sent to the current user
            //            query = PFQuery(className: "ChatMessage")
            //            //query.whereKey("receiver_user_id", equalTo: PFUser.current()?["userId"] as! String)
            //
            //            query.findObjectsInBackground(block: { (results:[PFObject]?, error:Error?) in
            //
            //                if let error = error {
            //                    print(error.localizedDescription)
            //                }
            //                else {
            //                    for result in results! {
            //                        self.messages.append(result)
            //                    }
            //                }
            //            })
            
            //            messages?.sort { (message0, message1) -> Bool in
            //                message1["updateAt"].compare(message0["updateAt"])
            //            }
            
            //            let userQuery = PFQuery(className: "_User")
            //            userQuery.limit = 1000
            //            // fetch data asynchronously
            //            userQuery.findObjectsInBackground { (users: [PFObject]?, error: Error?) -> Void in
            //                if let users = users {
            //                    // do something with the data fetched
            //                    self.users = users
            //                    //print("USERS")
            //                    //print(users)
            //                    self.tableView.reloadData()
            //
            //                } else {
            //                    // handle error
            //                    print(error?.localizedDescription)
            //                }
            //            }
        }
    }
    
    func timeSinceString(time: Int) -> String {
        var timeString: String?
        
        if(time/60 < 60) {
            timeString = "\(time/60) m"
        } else if(time/3600 < 24) {
            timeString = "\(time/3600) h"
        } else {
            timeString = "\(time/86400) d"
        }
        
        return timeString!
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
