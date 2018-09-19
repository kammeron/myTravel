//
//  SingleTripTableViewController.swift
//  myTravel
//
//  Created by Tiange Wang on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import CoreData

class SingleTripTableViewController: UITableViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var tableData = [Spots]()
    var tripSelected = MyTravel()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }
    
    func fetchAll() {
        let request:NSFetchRequest = Spots.fetchRequest()
        do {
            let result = try managedObjectContext.fetch(request)
            tableData = result as! [Spots]
        } catch {
            print("\(error)")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AddPlaceViewController
        destination.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as! TripCell
        cell.locationLabel.text = tableData[indexPath.row].name
        return cell
    }

}

extension SingleTripTableViewController: AddPlaceDelegate{
    func addPlace(_ name: String, _ address: String, _ latitude: String, _ longitude: String, _ trip: MyTravel) {
        let spot = Spots(context: managedObjectContext)
        spot.name = name
        spot.address = address
        spot.latitude = latitude
        spot.longitude = longitude
        tripSelected = trip
        tripSelected.addToSpots(spot)
        saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }


}

