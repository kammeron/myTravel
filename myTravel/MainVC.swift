//
//  MainVC.swift
//  myTravel
//
//  Created by Kammeron Nhieu on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    let key = "AIzaSyBwiQRbzK3aLVLy34fjHKoEaJxkUhpdvv8"
    let thisLatitude = "-33.8670522"
    let thisLongitude = "151.1957362"
    let thisRadius = "500"
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    var tableData = [MyTravel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=150.0
//        getPlaces()
        // Do any additional setup after loading the view, typically from a nib.
        fetchAll()
        print(tableData)
    }
    
    func fetchAll() {
        let request:NSFetchRequest = MyTravel.fetchRequest()
        do {
            let result = try managedObjectContext.fetch(request)
            tableData = result as! [MyTravel]
        } catch {
            print("\(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTripSegue" {
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! MyTravelViewController
            dest.delegate = self
        } else if segue.identifier == "TripDetailSegue" {
            // Nothing for now
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        managedObjectContext.delete(tableData[indexPath.row])
        saveContext()
        tableData.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func getPlaces() {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(thisLatitude),\(thisLongitude)&radius=\(thisRadius)&types=food&name=harbour&key=\(key)")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print(jsonResult)
                }
            } catch {
                print(error)
            }
        })
        // execute the task and then wait for the response
        // to run the completion handler. This is async!
        task.resume()
    }

}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTravelCell", for: indexPath) as! TravelCell
        cell.travelNameLabel.text = tableData[indexPath.row].name
        cell.destinationLabel.text = tableData[indexPath.row].destination
        cell.startLabel.text = "\(String(describing: tableData[indexPath.row].startDate))"
        cell.endLabel.text = "\(String(describing: tableData[indexPath.row].endDate))"
        cell.descriptionLabel.text = tableData[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TripDetailSegue", sender: indexPath)
    }
    
}

extension MainVC: MyTravelDelegate {

    func addMyTravel(_ name: String, _ destination: String, _ startOn: String, _ endOn: String, _ description: String) {
        let myTravel = NSEntityDescription.insertNewObject(forEntityName: "MyTravel", into: managedObjectContext) as! MyTravel
        myTravel.name = name
        myTravel.destination = destination
        myTravel.startDate = startOn
        myTravel.endDate = endOn
        myTravel.details = description
        tableData.append(myTravel)
        appDelegate.saveContext()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

