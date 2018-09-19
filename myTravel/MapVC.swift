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
    var thisLatitude = ""
    var thisLongitude = ""
    var thisRadius = "4000"
    var thisType = ""
    var locResults: [NSDictionary] = [NSDictionary]()
    let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
    let annotation = MKPointAnnotation()
    
    var selectedAnno: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        let region: MKCoordinateRegion = MKCoordinateRegionMake(Global.shared.myLocation!, span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        thisLatitude = Global.shared.latitude
        thisLongitude = Global.shared.longitude
        getPlaces()
        // Do any additional setup after loading the view.
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
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        for i in 0...self.locResults.count - 1 {
                            let geo = self.locResults[i]["geometry"] as! NSDictionary
                            let loc = geo["location"] as! NSDictionary
                            let lat = loc["lat"]
                            let lng = loc["lng"]
                            let annotation = MKPointAnnotation()
                            annotation.title = (self.locResults[i]["name"] as! String)
                            
                            annotation.coordinate = CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees)
                            self.mapView.addAnnotation(annotation)
                        }
                        
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
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        self.selectedAnno = view.annotation as? MKPointAnnotation
        print(view)
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
        cell.detailTextLabel?.text = "Rating: \(locResults[indexPath.row]["rating"]!)"
        return cell
    }
}





