//
//  MainViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private static let FETCH_URL = Common.BASE_URL + "fetch"
    
    private var images: [Int: UIImage] = [:] {
        didSet {
            if let shares = self.shares {
                if self.images.count == shares.count && self.images.count != 0 {
                    // success
                    self.doCommon(done: true)
                    lblMsg.text = ""
                    txtSearch.text = nil
                    tblView.reloadData()
                }
            }
        }
    }
    private var name = ""
    private var shares: Array<NSObject>?
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var btnOutRefresh: UIButton!
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        self.images = [:]
        self.getShares()
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        txtSearch.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let txt = txtSearch.text {
            if !txt.isEmpty {
                self.btnRefresh(btnOutRefresh)
            }
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // refresh
        self.btnRefresh(btnOutRefresh)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let uname = UserDefaults.standard.value(forKey: "name") {
            self.name = uname as! String
        }
        
        self.navItem.title = "Picer: \(self.name)"
        
        // set delegate and data source
        tblView.delegate = self
        tblView.dataSource = self
        
        txtSearch.delegate = self
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "setName" {
            UserDefaults.standard.removeObject(forKey: "name")
        }
        return true
    }
    
    private func getShares() {
        let url = NSURL(string: MainViewController.FETCH_URL)
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var t = ""
        if let txt = txtSearch.text {
            if !txt.isEmpty {
                t = txt
            }
        }
        let postString = "fetch=1&data=\(t)"
        request.httpBody = postString.data(using: .utf8)
        
        self.doCommon(done: false)
        lblMsg.text = "Loading..."
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error = \(String(describing: error))")
                DispatchQueue.main.async(execute: {
                    self.doError(1)
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
                        self.doError(2)
                    });
                }
                
            } catch {
                // print(error)
                DispatchQueue.main.async(execute: {
                    self.doError(3)
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
    }
    
    private func doSuccess(_ json: NSDictionary?) {
        if let strJson = json {
            if let shares = strJson.value(forKey: "data") as? Array<NSObject> {
                self.shares = shares
                // print(self.shares!)
                // tblView.reloadData()
                startDownloading(shares)
            }
        }
    }
    
    private func doError(_ data: Any? = nil) {
        self.doCommon(done: true)
        lblMsg.text = "No posts to see."
        txtSearch.text = nil
        
        if let d = data {
            print(d)
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shares = self.shares else {
            return 0
        }
        
        return shares.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareCell", for: indexPath) as! ShareTableViewCell
        
        if let shares = self.shares {
            let share = shares[indexPath.row]
            cell.set(data: share)
            if let image = self.images[indexPath.row] {
                // cell.set(image: image)
                cell.imgView.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //if let img = cell.imgView.image {
        //    return img.size.height + CGFloat(64)
        //}

        if let image = self.images[indexPath.row] {
            let maxWidth = self.view.frame.size.width
            let imgWidth = image.size.width
            let diff = maxWidth - imgWidth
            var add: CGFloat = 0
            if diff >= 0 {
                // add this diff to height of cell
                add = CGFloat(diff)
            }
            return image.size.height + CGFloat(128) + add
        }
        
        return 0
    }
    
    private func startDownloading(_ shares: Array<NSObject>) {

        for (index, share) in shares.enumerated() {
            if let imgStr = share.value(forKey: "image") as? String {
                self.downloadImage(at: index, urlStr: imgStr)
            }
        }
        
    }
    
    private func downloadImage(at index: Int, urlStr: String) {
        let imgUrl = URL(string: Common.BASE_URL + "uploads/" + urlStr)!
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: imgUrl) { (data, response, error) in
            // The download has finished.
            if let _ = error {
                // print("Error downloading cat picture: \(e)")
                return
            }
            // No errors found.
            // It would be weird if we didn't have a response, so check for that too.
            if let _ = response as? HTTPURLResponse {
                if let imageData = data {
                    // Finally convert that Data into an image and do what you wish with it.
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async(execute: {
                            self.images[index] = image
                        });
                    }
                }
            }
            
        }
        
        downloadPicTask.resume()
    }
}

