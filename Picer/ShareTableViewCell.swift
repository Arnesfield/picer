//
//  ShareTableViewCell.swift
//  Picer
//
//  Created by Jefferson Rylee on 20/11/2017.
//  Copyright © 2017 iOS Arnesfield. All rights reserved.
//

import UIKit

class ShareTableViewCell: UITableViewCell {

    private var cellData: NSObject?
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblDatetime: UILabel!
    @IBOutlet weak var lblLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                imgView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                imgView.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func set(image: UIImage) {
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: imgView, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = 999
        
        aspectConstraint = constraint
        
        imgView.image = image
    }
    
    func set(data: NSObject) {
        self.cellData = data
        
        if let name = data.value(forKey: "name") as? String {
            self.lblUser.text = name
        }
        if let datetime = data.value(forKey: "datetime") as? String {
            self.lblDatetime.text = datetime
        }
        if let label = data.value(forKey: "label") as? String {
            self.lblLabel.text = label
        }
        
    }

    
}
