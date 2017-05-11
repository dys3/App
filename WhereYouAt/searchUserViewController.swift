//
//  searchUserViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 5/9/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse

class searchUserViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var results: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        fetchingUsers(content: "")
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
