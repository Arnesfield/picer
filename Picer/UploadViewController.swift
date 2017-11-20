//
//  UploadViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private static let URL: String = Common.BASE_URL + "upload"
    
    @IBOutlet weak var btnNavTitle: UINavigationItem!
    @IBOutlet weak var btnOutShare: UIBarButtonItem!
    @IBOutlet weak var btnOutCamera: UIButton!
    @IBOutlet weak var btnOutGallery: UIButton!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func btnCamera(_ sender: UIButton) {
        self.selectPhotoFrom(photoLibrary: false)
    }
    
    @IBAction func btnGalery(_ sender: UIButton) {
        self.selectPhotoFrom(photoLibrary: true)
    }
    
    @IBAction func btnShare(_ sender: UIBarButtonItem) {
        self.doUpload()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func selectPhotoFrom(photoLibrary: Bool) -> Void {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = photoLibrary ? .photoLibrary : .camera
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtField.delegate = self
        
        var name = ""
        if let uname = UserDefaults.standard.value(forKey: "name") {
            name = uname as! String
        }
        
        self.btnNavTitle.title = "Upload: \(name)"
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        txtField.resignFirstResponder()
    }

    private func doUpload() {
        guard let viewImage = self.imgView.image else {
            lblMsg.text = "Choose an image."
            return
        }
        
        guard let imageData = UIImageJPEGRepresentation(viewImage, 1) else {
            return
        }
        
        guard let lbl = txtField.text else {
            lblMsg.text = "A label is also required."
            return
        }
        
        
        var name = ""
        let label = lbl
        
        if let uname = UserDefaults.standard.value(forKey: "name") {
            name = uname as! String
        }
        
        
        let url = NSURL(string: UploadViewController.URL)
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        
        let param = [
            "name": name,
            "label": label
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "image", imageDataKey: imageData as NSData, boundary: boundary) as Data
        
        self.doCommon(done: false)
        lblMsg.text = "Uploading..."
        
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
                        self.doSuccess()
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
        txtField.isEnabled = done
        btnOutCamera.isEnabled = done
        btnOutGallery.isEnabled = done
        btnOutShare.isEnabled = done
    }
    
    private func doSuccess() {
        self.doCommon(done: true)
        self.imgView.image = nil
        self.txtField.text = ""
        self.lblMsg.text = "Successfully shared photo!"
    }
    
    private func doError() {
        self.doCommon(done: true)
        self.lblMsg.text = "Cannot upload photo."
    }
    
    private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "some-image.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        // print(body)
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
