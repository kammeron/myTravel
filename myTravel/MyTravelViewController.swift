//
//  MyTravelViewController.swift
//  myTravel
//
//  Created by Tenju Paul on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit

protocol MyTravelDelegate{
    func addMyTravel(_ name: String, _ destination: String, _ startOn: String, _ endOn: String, _ description: String, at indexPath: NSIndexPath?)
    func cancelModel()
}

class MyTravelViewController: UIViewController {
    
    var delegate: MyTravelDelegate!
    var nameCatch: String?
    var destCatch: String?
    var startCatch: String?
    var endCatch: String?
    var descCatch: String?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBAction func addPressed(_ sender: UIButton) {
        delegate.addMyTravel(nameTextField.text!, destinationTextField.text!, startDateField.text!, endDateField.text!, descriptionField.text!, at: indexPath)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        delegate.cancelModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = nameCatch
        destinationTextField.text = destCatch
        startDateField.text = startCatch
        endDateField.text = endCatch
        descriptionField.text = descCatch
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
