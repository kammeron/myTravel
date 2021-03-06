//
//  TripCell.swift
//  myTravel
//
//  Created by Tiange Wang on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit

protocol TripCellDelegate{
    func getDirections(_ sender: IndexPath)
}

class TripCell: UITableViewCell {
    
    var delegate: TripCellDelegate!
    var indexPath: IndexPath!
    
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBAction func getDirection(_ sender: UIButton) {
        delegate.getDirections(indexPath)
    }
    
}
