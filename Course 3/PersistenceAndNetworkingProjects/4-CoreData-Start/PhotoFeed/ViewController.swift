//
//  ViewController.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-07.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateDateLabel()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDateLabel () {
        let lastUpdate = UserDefaults.standard.object(forKey: "buttonTapped") as? Date
        if let hasLastUpdate = lastUpdate {
            self.dateLabel.text = hasLastUpdate.description
        } else {
            self.dateLabel.text = "No date saved."
        }
    }


    @IBAction func updateButtonAction(_ sender: AnyObject) {
        let now = Date()
        UserDefaults.standard.set(now, forKey: "buttonTapped")
        self.updateDateLabel()
    }
    
}

