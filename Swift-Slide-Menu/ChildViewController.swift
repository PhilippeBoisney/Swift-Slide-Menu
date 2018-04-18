//
//  ChildViewController.swift
//  Swift Slide Menu
//
//  Created by Philippe Boisney on 02/10/2015.
//  Copyright © 2015. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        createOrResizeView(height: (self.parent?.view.frame.size.width)!, width: (self.parent?.view.frame.size.height)!)
        
    }
    override func viewDidLayoutSubviews() {
        
        createOrResizeView(height: (self.parent?.view.frame.size.height)!, width: (self.parent?.view.frame.size.width)!)
        
    }
    
    
    //MARK: Others Functions ------------------------------------------------
    
    // Allows to resize child view during rotation
    func createOrResizeView(height :CGFloat, width: CGFloat){
        var newFrame: CGRect = (self.parent?.view.frame)!
        newFrame.size.height = height
        newFrame.size.width = width
        self.view.frame = newFrame
    }
    
    
    
}
