//
//  ChatListViewController.swift
//  WhereYouAt
//
//  Created by Richard Du on 4/26/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    // hardcoding the current user
    let _currentUser : User
    
    @IBOutlet weak var tableView: UITableView!
    

    
    var messages : [NSObject]
    var usersID : [String]
    
    var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetching()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userID = usersID {
            return usersID.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        var user: User?
        
        var query = PFQuery(className: "User")
        query.whereKey("objectID", equalTo: usersID[indexPath.row])
        
        query.findObjectsInBackground { (results, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                user = results[0]
            }
        }
        
        cell.user = user
        cell.userNameLabel = user["screenName"]
        
        var latestMessage = getLatestMessage(userId: user["objectId"])
        cell.textLabel?.text = latestMessage["text"]
        
        cell.timeLabel.text = latestMessage["updateAt"]
    }
    
    func fetching() {
        if !isFetching {
            self.isFetching = true
            var query = PFQuery(className: "ChatMessage")
            
            // getting messages that sent from current user
            query.whereKey("sender_user_id", equalTo: _currentUser.id)
            
            query.findObjectsInBackground(block: { (results:[PFObject]?, error:Error?) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    messages.append(results)
                }
            })
            
            // getting messages that sent to the current user
            query = PFQuery(className: "ChatMessage")
            query.whereKey("receiver_user_id", equalTo: _currentUser.id)
            
            query.findObjectsInBackground(block: { (results:[PFObject]?, error:Error?) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    messages.append(results)
                }
            })
            
            messages.sort { (message0, message1) -> Bool in
                message1["updateAt"].compare(message0["updateAt"])
            }
            
            for message in messages {
                if message.senderID == _currentUser.id  {
                    
                    !(usersID.contains(message["receiver_user_id"])) {
                    usersID.append(sentMessage["receiver_user_id"])
                    }
                }
                else {
                    !(usersID.contains(message["senter_user_id"])) {
                    usersID.append(message["senter_user_id"])
                    }
                }
            }
            
            

        }
    }
    
    func getLatestMessage(userId : String) -> NSObject {
        for message in messages {
            if (message["senter_user_id"] == _currentUser.id && message["receiver_user_id"] == userId) || (message["senter_user_id"] == userId && message["receiver_user_id"] == _currentUser.id) {
                return message
            }
        }
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let userID = movies![indexPath!.row]
        let ChatVC = segue.destination as! ChatViewController
        ChatVC.userID = userID
    }
    

}


