//
//  EventsViewController.swift
//  WhereYouAt
//
//  Created by SongYuda on 4/23/17.
//  Copyright © 2017 dys3. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AFNetworking

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var events : [PFObject]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
            
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.event = self.events?[indexPath.row]
        return cell
    }
    
    @IBAction func onClickNew(_ sender: Any) {
        self.performSegue(withIdentifier: "createNewEvent", sender: nil)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "createNewEvent" {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let event = self.events?[(indexPath?.row)!]
        let eventDetailVC = segue.destination as! EventDetailViewController
        eventDetailVC.event = event;
        }
    }
    

}
