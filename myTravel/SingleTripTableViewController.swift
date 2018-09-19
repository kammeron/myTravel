//
//  SingleTripTableViewController.swift
//  myTravel
//
//  Created by Tiange Wang on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SingleTripTableViewController: UITableViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var tableData = [Spots]()
    var tripSelected = MyTravel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        tableData = TripPlanShared.shared.trip.spots?.allObjects as! [Spots]
        fetchAll()
    }

    func fetchAll() {
        let request:NSFetchRequest = Spots.fetchRequest()
        do {
            let result = try managedObjectContext.fetch(request)
            tableData = result
            print(tableData)
        } catch {
            print("\(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RouteSegue"{
            print("Prepare Segue: \(tableData[(sender as! IndexPath).row].latitude)")
            let destination = segue.destination as! RouteDetailViewController
            destination.endLoc = CLLocationCoordinate2D.init(latitude: tableData[(sender as! IndexPath).row].latitude, longitude:tableData[(sender as! IndexPath).row].longitude)
            destination.startLoc = CLLocationCoordinate2D.init(latitude: tableData[(sender as! IndexPath).row - 1].latitude, longitude:tableData[(sender as! IndexPath).row - 1].longitude)
            destination.displayStart = "Start Location: \(tableData[(sender as! IndexPath).row - 1].name!)"
            destination.displayDest = "Destination: \(tableData[(sender as! IndexPath).row].name!)"
        }else if segue.identifier == "AddPlaceSegue"{
            let destination = segue.destination as! AddPlaceViewController
            destination.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell") as! TripCell
        cell.locationLabel.text = tableData[indexPath.row].name
        cell.delegate = self
        cell.indexPath = indexPath
        if indexPath.row == 0{
            cell.directionButton.isHidden = true
        }
        return cell
    }
    
    // REMOVE THIS LATER!!!!! DIRECTION SHOULD BE ACCESSED BY THE DIRECTION BUTTON. THIS IS FOR TESTING PURPOSE ONLY
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "RouteSegue", sender: indexPath)
//    }
    
    // ----------------------------------------------------

}

extension SingleTripTableViewController: AddPlaceDelegate{
    func addPlace(_ name: String, _ address: String, _ latitude: Double, _ longitude: Double, _ trip: MyTravel) {
        let spot = Spots(context: managedObjectContext)
        spot.name = name
        spot.address = address
        spot.latitude = latitude
        spot.longitude = longitude
        tripSelected = trip
        tripSelected.addToSpots(spot)
        tableData.append(spot)
        saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }


}

extension SingleTripTableViewController: TripCellDelegate{
    func getDirections(_ indexPath: IndexPath) {
        performSegue(withIdentifier: "RouteSegue", sender: indexPath)
    }
    
    
}

