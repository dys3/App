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

    var userID : String?
    
    // hardcoding the current user
    let _currentUser : User
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages : [NSObject]?
    
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
    
    @IBAction func onClickSend(_ sender: Any) {
        let messageToSend = Message(message: messageTextField.text!)
        var parseMessage = PFObject(className: "ChatMessage")
        parseMessage["Text"] = messageToSend.content
        parseMessage["sender_user_id"] = _currentUser.id
        parseMessage["receiver_user_id"] = userID
        parseMessage.saveInBackground { (success: Bool, error: Error?) in
            if(success) {
                print("saved")
                self.message.text = ""
            } else {
                
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
        cell.textLabel?.text = messages[indexPath.row]["Text"]
        
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
        
        cell.userLabel.text = user["username"]
    }

    
    func fetching () {
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
