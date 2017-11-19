//
//  UploadViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtField.delegate = self
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        txtField.resignFirstResponder()
    }

    

}
