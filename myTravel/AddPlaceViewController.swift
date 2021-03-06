//
//  AddPlaceViewController.swift
//  myTravel
//
//  Created by Tenju Paul on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddPlaceDelegate {
    func addPlace(_ name: String, _ address: String, _ latitude: Double, _ longitude: Double, _ trip: MyTravel)
}

class AddPlaceViewController: UIViewController {
    
    var delegate: AddPlaceDelegate!

    @IBOutlet weak var placeNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBAction func addPressed(_ sender: UIButton) {
        let geocoder = CLGeocoder()
        var lat = CLLocationDegrees()
        var lon = CLLocationDegrees()
        geocoder.geocodeAddressString(addressField.text!) {
            placemarks, error in
            let placemark = placemarks?.first
            
            lat = (placemark?.location?.coordinate.latitude)!
            lon = (placemark?.location?.coordinate.longitude)!
            print("Lat: \(lat), Lon: \(lon)")
            let latitude = lat
            let longitude = lon
            
            self.delegate.addPlace(self.placeNameField.text!, self.addressField.text!, latitude, longitude, TripPlanShared.shared.trip)
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddPlaceVC: \(TripPlanShared.shared.trip.name!)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
