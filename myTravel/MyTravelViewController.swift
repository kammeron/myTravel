//
//  MyTravelViewController.swift
//  myTravel
//
//  Created by Tenju Paul on 9/18/18.
//  Copyright © 2018 Kammeron Nhieu. All rights reserved.
//

import UIKit

protocol MyTravelDelegate{
    func addMyTravel(_ name: String, _ destination: String, _ startOn: String, _ endOn: String, _ description: String)
}

class MyTravelViewController: UITableViewController {
    
    var delegate: MyTravelDelegate!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        delegate.addMyTravel(nameTextField.text!, destinationTextField.text!, startDateField.text!, endDateField.text!, descriptionField.text!)
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  


}
