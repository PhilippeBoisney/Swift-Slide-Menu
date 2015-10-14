//
//  ViewController.swift
//  Swift-Slide-Menu
//
//  Created by Philippe Boisney on 05/10/2015.
//  Copyright © 2015 Philippe Boisney. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
        
        addChildView("HomeScreenID", titleOfChildren: "HOME", iconName: "home")
        addChildView("ContactScreenID", titleOfChildren: "CONTACT", iconName: "contact")
        addChildView("LoveScreenID", titleOfChildren: "LOVE", iconName: "love")
        addChildView("SettingsScreenID", titleOfChildren: "SETTINGS", iconName: "settings")
        
        
        //Show the first childScreen
        showFirstChild()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

