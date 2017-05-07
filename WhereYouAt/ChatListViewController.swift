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

class ChatListViewControlvar: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    

    
    var messages : [PFObject]!
    var usersID : [String]!
    
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
        if let userId = usersID {
            return userId.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        var user: PFObject!
        
        let query = PFQuery(className: "User")
        query.whereKey("objectID", equalTo: usersID?[indexPath.row])
        
        query.findObjectsInBackground { (results, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                user = (results?[0])!
            }
        }
        
        cell.user = user
        cell.userNameLabel.text = user["screenName"] as? String
        
        let latestMessage = getLatestMessage(userId: user["objectId"] as! String)
        cell.textLabel?.text = latestMessage["text"] as? String
        
        cell.timeLabel.text = latestMessage["updateAt"] as? String
        
        return cell
    }
    
    func fetching() {
        if !isFetching {
            self.isFetching = true
            var query = PFQuery(className: "ChatMessage")
            
            // getting messages that sent from current user
            query.whereKey("sender_user_id", equalTo: PFUser.current()?["userId"] as! String)
            
            query.findObjectsInBackground(block: { (results:[PFObject]?, error:Error?) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    for result in results! {
                        self.messages.append(result)
                    }
                }
            })
            
            // getting messages that sent to the current user
            query 	= PFQuery(className: "ChatMessage")
            query.whereKey("receiver_user_id", equalTo: PFUser.current()?["userId"] as! String)
            
            query.findObjectsInBackground(block: { (results:[PFObject]?, error:Error?) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    for result in results! {
                        self.messages.append(result)
                    }
                }
            })
            
//          messages?.sort { (message0, message1) -> Bool in
//              message1["updateAt"].compare(message0["updateAt"])
//          }
            
            for message in messages! {
                if ((message["sender_user_id"] as! String) == (PFUser.current()?["userId"] as! String))  {
                    
                    if !(usersID.contains(message["receiver_user_id"] as! String)) {
                        usersID.append(message["receiver_user_id"] as! String)
                    }
                }
                else {
                    if !(usersID.contains(message["senter_user_id"] as! String)) {
                        usersID.append(message["senter_user_id"] as! String)
                    }
                }
            }
            
            

        }
    }
    
    func getLatestMessage(userId : String) -> PFObject {
        for message in messages! {
            if ((message["senter_user_id"] as! String) == PFUser.current()?["userId"] as! String && (message["receiver_user_id"] as! String) == userId) || ((message["senter_user_id"] as! String) == userId && (message["receiver_user_id"] as! String) == PFUser.current()?["userId"] as! String) {
                return message
            }
        }
        let emptyMessage: PFObject?
        emptyMessage = nil
        return emptyMessage!
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let userId = usersID[indexPath!.row]
        let ChatVC = segue.destination as! ChatViewController
        ChatVC.userID = userId
    }
    

}


