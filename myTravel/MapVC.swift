//
//  MapVCViewController.swift
//  myTravel
//
//  Created by Edward Shin on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let key = "AIzaSyBwiQRbzK3aLVLy34fjHKoEaJxkUhpdvv8"
    var thisLatitude = "37.375489318087"
    var thisLongitude = "-121.910261964237"
    var thisRadius = "5000"
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D?
    var thisType = ""
    var locResults: [NSDictionary] = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print("ViewDidLoad: \(thisLatitude)")
        print("ViewDidLoad: \(thisLongitude)")
        getPlaces()
        print("after lat: \(thisLatitude)")
        print("after long: \(thisLatitude)")
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        thisLatitude = String(location.coordinate.latitude)
        thisLongitude = String(location.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // get api functions
    
    func getPlaces() {
        print(thisLatitude)
        print(thisLongitude)
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(thisLatitude),\(thisLongitude)&radius=\(thisRadius)&types=point_of_interest&key=\(key)")
//        print(url)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                    print(jsonResult)
                    
                    let results = jsonResult["results"]
                    self.locResults = results as! [NSDictionary]
                    print(self.locResults)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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

extension MapVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        
        cell.textLabel?.text = locResults[indexPath.row]["name"] as! String
//        cell.detailTextLabel?.text = locResults[indexPath.row]["rating"] as! String
        cell.detailTextLabel?.text = "rating: \(locResults[indexPath.row]["rating"]!)"
        return cell
    }
}





