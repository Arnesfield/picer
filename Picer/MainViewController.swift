//
//  MainViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var name = ""
    @IBOutlet weak var navItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let uname = UserDefaults.standard.value(forKey: "name") {
            self.name = uname as! String
        }
        
        self.navItem.title = "Picer: \(self.name)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
