//
//  SingleTripTableViewController.swift
//  myTravel
//
//  Created by Tiange Wang on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit

class SingleTripTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as! TripCell
        cell.locationLabel.text = "\(indexPath.row)"
        return cell
    }
    
    // REMOVE THIS LATER!!!!! DIRECTION SHOULD BE ACCESSED BY THE DIRECTION BUTTON. THIS IS FOR TESTING PURPOSE ONLY
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RouteSegue", sender: indexPath)
    }
    
    // ----------------------------------------------------

}
