//
//  WelcomeViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let name = UserDefaults.standard.value(forKey: "name") as! String
        
        self.lblName.text = "Hi, \(name)."
    }

}
