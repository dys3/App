//
//  searchUserViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/9/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class searchUserViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var results: [PFObject]!
    var friends: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        fetchingUsers(content: "")
        if let friendsList = fetchFriends() {
            friends = friendsList
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = results {
            return results.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! searchUserCell
        
        cell.user = results[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = PFUser.current()
        var userFriends: [PFObject]!
        
        let addFriendAlertController = UIAlertController(title: "Add friend?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.results[indexPath.row].fetchInBackground { (result, error) in
                
                if user?["friends"] == nil {
                    if let result = result {
                        print(result["username"])
                        user?.add(result["username"], forKey: "friends")
                        user?.saveInBackground()
                    } else {
                        print(error?.localizedDescription)
                    }
                } else {
                    // filter user here
                    /*
                     if let friends = user?["friends"] as? [PFObject] {
                     for friend in friends {
                     if friend == result {
                     containFriend = true
                     }
                     }
                     }*/
                    
                    //                    (user?["friends"] as AnyObject).fetchInBackground(block: { (friends, error) in
                    //                        if let friends = friends {
                    //                            print("check")
                    //                        } else {
                    //                            print(error?.localizedDescription)
                    //                        }
                    //                    })
                    
                    
                    if let result = result {
                        print(result["username"])
                        user?.add(result["username"], forKey: "friends")
                        user?.saveInBackground()
                    } else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
        
        addFriendAlertController.addAction(cancelAction)
        addFriendAlertController.addAction(addAction)
        self.present(addFriendAlertController, animated: true)
    }
    
    //    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //
    //        if searchBar.text == "" {
    //            fetchingUsers(content: "")
    //        }
    //        else {
    //        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
    //        searchBar.showsCancelButton = true
    //        fetchingUsers(content: newText)
    //        }
    //        return true
    //    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        fetchingUsers(content: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        print("canceled")
        fetchingUsers(content: "")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchingUsers(content: searchBar.text!)
    }
    
    func fetchingUsers(content: String) {
        let query = PFQuery(className: "_User").whereKey("username", matchesRegex: content, modifiers: "i")
        query.whereKey("username", notEqualTo: PFUser.current()?["username"])
        
        query.order(byAscending: "username")
        query.findObjectsInBackground { (results, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else {
                self.results = results
                self.tableView.reloadData()
            }
        }
        
    }
    
    func fetchFriends() -> [PFObject]? {
        let user = PFUser.current()
        let friends = user!["friends"] as? [PFObject]
        return friends
        
    }
    
    //    func filterUser(friend: PFObject) -> Bool {
    //        var friendBool: Bool = false
    //        let query = PFQuery(className: "_User")
    //        query.whereKey("friends", equalTo: friend)
    //        query.findObjectsInBackground { (result, error) in
    //            print("check")
    //            if let result = result {
    //                if result == nil {
    //                    // Do nothing
    //                    print("Added friend already")
    //                } else {
    //                    print("New friend!")
    //                    friendBool = true
    //                }
    //            } else {
    //                print(error?.localizedDescription)
    //            }
    //        }
    //        return friendBool
    //    }
    
    
    //    func tapAddFriends() {
    //        print("Add friend?")
    //        let user = PFUser.current()
    //        let addFriendAlertController = UIAlertController(title: "Add friend?", message: "", preferredStyle: .alert)
    //        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    //        let addFriendAction = UIAlertAction(title: "Add", style: .default) { (action) in
    //
    //            user?.add("CodePath Student", forKey: "friends")
    //
    //            user?.saveInBackground()
    //        }
    //        addFriendAlertController.addAction(cancelAction)
    //        addFriendAlertController.addAction(addFriendAction)
    //        self.present(addFriendAlertController, animated: true) {
    //        }
    //
    //        for result in results {
    //            print(result)
    //        }
    //    }
    
    /*
     event.saveInBackground { (success, error) in
     if success {
     print("saved")
     self.delegate.afterPost(controller: self)
     self.dismiss(animated: true, completion: nil)
     }
     else {
     print(error?.localizedDescription)
     }
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
