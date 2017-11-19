//
//  UploadViewController.swift
//  Picer
//
//  Created by Jefferson Rylee on 19/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func btnCamera(_ sender: UIButton) {
        self.selectPhotoFrom(photoLibrary: false)
    }
    
    @IBAction func btnGalery(_ sender: UIButton) {
        self.selectPhotoFrom(photoLibrary: true)
    }
    
    @IBAction func btnPost(_ sender: UIBarButtonItem) {
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
    }
    
    @IBAction func tapHandler(_ sender: UITapGestureRecognizer) {
        txtField.resignFirstResponder()
    }

    

}
