//
//  ViewController.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-07.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateDateLabel()
    }
    
    func updateDateLabel() {
        let lastUpdate = UserDefaults.standard.object(forKey: "buttonTapped") as? Date
        if let hasLastUpdate = lastUpdate {
            dateLabel.text = hasLastUpdate.description
        } else {
            dateLabel.text = "No date saved."
        }
    }

    @IBAction func updateButtonAction(_ sender: AnyObject) {
        let now = Date()
        UserDefaults.standard.set(now, forKey: "buttonTapped")
        updateDateLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

