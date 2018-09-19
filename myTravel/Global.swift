//
//  Global.swift
//  myTravel
//
//  Created by Kammeron Nhieu on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit
import CoreLocation

class Global {
    static var shared = Global()
    var myLocation: CLLocationCoordinate2D?
    var latitude = ""
    var longitude = ""
}
