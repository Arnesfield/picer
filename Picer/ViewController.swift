//
//  ViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let res = shouldPerformSegue(withIdentifier: "setName", sender: btnNext)
        textField.resignFirstResponder()
        if res {
            performSegue(withIdentifier: "setName", sender: btnNext)
        }
        return res
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        txtName.resignFirstResponder()
        if !txtName.text!.isEmpty {
            if (identifier == "setName") {
                let name = txtName.text
                UserDefaults.standard.set(name, forKey: "name")
            }
            return true
        }
        
        return false
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        txtName.resignFirstResponder()
    }
    
    private func unsetName() {
        UserDefaults.standard.removeObject(forKey: "name")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // unsetName()
        
        txtName.delegate = self
        
        // go to next if has name
        if UserDefaults.standard.value(forKey: "name") != nil {
            self.view.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "name") != nil {
            performSegue(withIdentifier: "hasName", sender: nil)
        }
    }

}

