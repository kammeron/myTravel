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
    var nameTemp: String?
    var destTemp: String?
    var startTemp: String?
    var endTemp: String?
    var descTemp: String?
    var ipTemp: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight=170.0
//        getPlaces()
        fetchAll()
    }
    
    func fetchAll() {
        let request:NSFetchRequest = MyTravel.fetchRequest()
        do {
            let result = try managedObjectContext.fetch(request)
            tableData = result
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
            let dest = segue.destination as! MyTravelViewController
            dest.delegate = self
        } else if segue.identifier == "EditTripSegue" {
            let dest = segue.destination as! MyTravelViewController
            dest.delegate = self
            dest.nameCatch = nameTemp!
            dest.destCatch = destTemp!
            dest.startCatch = startTemp!
            dest.endCatch = endTemp!
            dest.descCatch = descTemp!
            dest.indexPath = ipTemp!
        } else if segue.identifier == "TripDetailSegue" {
            print(tableData[(sender as AnyObject).row].name!)
            TripPlanShared.shared.trip = tableData[(sender as AnyObject).row]
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        managedObjectContext.delete(tableData[indexPath.row])
//        saveContext()
//        tableData.remove(at: indexPath.row)
//        tableView.reloadData()
//    }
    
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
        cell.startLabel.text = "\(String(describing: tableData[indexPath.row].startDate!))"
        cell.endLabel.text = "\(String(describing: tableData[indexPath.row].endDate!))"
        cell.descriptionLabel.text = tableData[indexPath.row].details
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TripDetailSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.managedObjectContext.delete(self.tableData[indexPath.row])
            self.saveContext()
            self.tableData.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.nameTemp = self.tableData[indexPath.row].name
            self.destTemp = self.tableData[indexPath.row].destination
            self.startTemp = "\(String(describing: self.tableData[indexPath.row].startDate!))"
            self.endTemp = "\(String(describing: self.tableData[indexPath.row].endDate!))"
            self.descTemp = self.tableData[indexPath.row].details
            self.ipTemp = indexPath as NSIndexPath
            self.performSegue(withIdentifier: "EditTripSegue", sender: indexPath)
        }
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
    }
    
}

extension MainVC: MyTravelDelegate {
    
    func addMyTravel(_ name: String, _ destination: String, _ startOn: String, _ endOn: String, _ description: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            tableData[ip.row].name = name
            tableData[ip.row].destination = destination
            tableData[ip.row].startDate = startOn
            tableData[ip.row].endDate = endOn
            tableData[ip.row].details = description
            saveContext()
            tableView.reloadData()
        } else {
            let myTravel = NSEntityDescription.insertNewObject(forEntityName: "MyTravel", into: managedObjectContext) as! MyTravel
            myTravel.name = name
            myTravel.destination = destination
            myTravel.startDate = startOn
            myTravel.endDate = endOn
            myTravel.details = description
            tableData.append(myTravel)
            saveContext()
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    func cancelModel() {
        dismiss(animated: true, completion: nil)
    }
}

