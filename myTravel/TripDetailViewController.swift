//
//  TripDetailViewController.swift
//  myTravel
//
//  Created by Tiange Wang on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import MapKit

class TripDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let london = CLLocationCoordinate2DMake(51.528308, -0.3817765)
    
    @IBAction func goBackBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView = MKMapView.init()
        self.view.addSubview(self.mapView)
        self.mapView.centerCoordinate = self.london
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mapView.frame = CGRect.init(origin: CGPoint.zero, size: view.frame.size);
    }

}
