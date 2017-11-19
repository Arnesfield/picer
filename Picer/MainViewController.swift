//
//  MainViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private static let URL = Common.BASE_URL + "fetch"
    
    private var name = ""
    private var shares: Array<NSObject>?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var btnOutRefresh: UIButton!
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        self.getShares()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let uname = UserDefaults.standard.value(forKey: "name") {
            self.name = uname as! String
        }
        
        self.navItem.title = "Picer: \(self.name)"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "setName" {
            UserDefaults.standard.removeObject(forKey: "name")
        }
        return true
    }
    
    private func getShares() {
        let url = NSURL(string: MainViewController.URL)
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "fetch=1"
        request.httpBody = postString.data(using: .utf8)
        
        self.doCommon(done: false)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                // print("error = \(String(describing: error))")
                DispatchQueue.main.async(execute: {
                    self.doError()
                });
                return
            }
            
            // print("response = \(String(describing: response))")
            
            // let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            // print("response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                // print(json!)
                
                let success = json?.value(forKey: "success") as! Int
                
                if success == 1 {
                    DispatchQueue.main.async(execute: {
                        self.doSuccess(json)
                    });
                }
                else  {
                    DispatchQueue.main.async(execute: {
                        self.doError()
                    });
                }
                
            } catch {
                // print(error)
                DispatchQueue.main.async(execute: {
                    self.doError()
                });
            }
            
            
        }
        
        task.resume()
    }

    private func doCommon(done: Bool) {
        if done {
            indicator.stopAnimating()
        }
        else {
            indicator.startAnimating()
        }
        btnOutRefresh.isEnabled = done
        lblMsg.text = done ? "" : "Loading..."
    }
    
    private func doSuccess(_ json: NSDictionary?) {
        self.doCommon(done: true)
        if let strJson = json {
            self.shares = strJson.value(forKey: "data") as? Array<NSObject>
            // print(self.shares!)
        }
    }
    
    private func doError() {
        self.doCommon(done: true)
    }
    
}

