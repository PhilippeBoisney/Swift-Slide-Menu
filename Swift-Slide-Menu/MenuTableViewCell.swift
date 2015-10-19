//
//  MenuTableViewCell.swift
//  Swift Slide Menu
//
//  Created by Philippe Boisney on 05/10/2015.
//  Copyright © 2015. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var img = UIImageView()
    var label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func initViews() {
        
        var newFrameForLabel: CGRect = (self.frame)
        newFrameForLabel.size.height = self.frame.height*0.5
        newFrameForLabel.size.width = self.frame.width*0.8
        
        label.frame = newFrameForLabel
        label.textColor = UIColor.blackColor()
        label.font = UIFont(name: "Avenir", size: 15)
        
        
        var newFrameForImage: CGRect = (self.frame)
        newFrameForImage.size.height = self.frame.height*0.8
        newFrameForImage.size.width = self.frame.height*0.8
        img = UIImageView(frame: newFrameForImage)
        
        self.contentView.addSubview(img)
        self.contentView.addSubview(label)
        
        setConstraints()
    }
    
    func setConstraints(){
        
        label.translatesAutoresizingMaskIntoConstraints = false
        img.translatesAutoresizingMaskIntoConstraints = false
        
        //Vertical Constraints
        let verticalConstraintImg = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let verticalConstraintLabel = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        //Height and Width Constraints
        let widthConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.4, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: img, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 0.4, constant: 0)
        
        //Visual Constraints
        let views = Dictionary(dictionaryLiteral: ("image",img),("label",label))
        
        let imageLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[image]-15-[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        self.contentView.addConstraints(imageLabelConstraints)
        self.contentView.addConstraint(widthConstraint)
        self.contentView.addConstraint(heightConstraint)
        self.contentView.addConstraint(verticalConstraintImg)
        self.contentView.addConstraint(verticalConstraintLabel)
    }
    
    
    
}
