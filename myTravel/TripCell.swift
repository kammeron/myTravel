//
//  TripCell.swift
//  myTravel
//
//  Created by Tiange Wang on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit

protocol TripCellDelegate {
    func getDir(_ seq: Int)
}

class TripCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBAction func getDirection(_ sender: UIButton) {
    }
    
}