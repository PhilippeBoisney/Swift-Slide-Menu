//
//  BaseViewController.swift
//  Swift Slide Menu
//
//  Created by Philippe BOISNEY 10/01/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var tabOfChildViewController: [UIViewController] = []
    var tabOfChildViewControllerName: [String] = []
    var tabOfChildViewControllerIconName: [String] = []
    
    var menuToReturn = [Dictionary<String,String>]()
    
    var imageNameHeaderMenu: String = "background"
    
    var objMenu : TableViewMenuController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create containerView that contain child view
        createContainerView()
        
        //Show the SlideMenu and it's button
        self.addSlideMenuButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func slideMenuItemSelectedAtIndex(index: Int32) {
        if (index>=0) {
            self.title=tabOfChildViewControllerName[Int(index)]
            transitionBetweenTwoViews(tabOfChildViewController[Int(index)])
        }
    }
    
    func addSlideMenuButton(){
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let btnShowMenu = ZFRippleButton()
        btnShowMenu.alpha = 0
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Highlighted)
        btnShowMenu.frame = CGRectMake(0, 0, navigationBarHeight, navigationBarHeight)
        btnShowMenu.addTarget(self, action: "onSlideMenuButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(27, 22), false, 0.0)
        UIColor.whiteColor().setFill()
        UIBezierPath(rect: CGRectMake(0, 3, 27, 2)).fill()
        UIBezierPath(rect: CGRectMake(0, 10, 27, 2)).fill()
        UIBezierPath(rect: CGRectMake(0, 17, 27, 2)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (sender.tag == 10)
        {
            // Menu is already displayed, no need to display it twice, otherwise we hide the menu
            sender.tag = 0;
            
            //Remove Menu View Controller
            objMenu.animateWhenViewDisappear()
            return
        }
        
        sender.enabled = false
        sender.tag = 10
        
        //Create Menu View Controller
        objMenu = TableViewMenuController()
        objMenu.setMenu(menuToReturn)
        objMenu.setImageName(imageNameHeaderMenu)
        objMenu.btnMenu = sender
        objMenu.delegate = self
        self.view.addSubview(objMenu.view)
        self.addChildViewController(objMenu)
        
        sender.enabled = true
        
        objMenu.createOrResizeMenuView()
        objMenu.animateWhenViewAppear()
    }
    
    //MARK: Functions for Container
    func transitionBetweenTwoViews(subViewNew: UIViewController){
        
        //Add new view
        addChildViewController(subViewNew)
        subViewNew.view.frame = (self.parentViewController?.view.frame)!
        view.addSubview(subViewNew.view)
        subViewNew.didMoveToParentViewController(self)
        
        //Remove old view
        if self.childViewControllers.count > 1 {
            
            //Remove old view
            let oldViewController: UIViewController = self.childViewControllers.first!
            oldViewController.willMoveToParentViewController(nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
        
        print("After Remove: \(self.childViewControllers.description)")
    }
    
    func createContainerView(){
        //Create View
        let containerViews = UIView()
        containerViews.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerViews)
        self.view.sendSubviewToBack(containerViews)
        
        //Height and Width Constraints
        let widthConstraint = NSLayoutConstraint(item: containerViews, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: containerViews, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        self.view.addConstraint(widthConstraint)
        self.view.addConstraint(heightConstraint)
        
        
    }
    
    //MARK: Methods helping users to customise Menu Slider
    
    //Add New Screen to Menu Slider
    func addChildView(storyBoardID: String, titleOfChildren: String, iconName: String) {
        
        let childViewToAdd: UIViewController = storyboard!.instantiateViewControllerWithIdentifier(storyBoardID)
        tabOfChildViewController += [childViewToAdd]
        tabOfChildViewControllerName += [titleOfChildren]
        tabOfChildViewControllerIconName += [iconName]
        
        menuToReturn.append(["title":titleOfChildren, "icon":iconName])
    }
    
    //Show the first child at startup of application
    func showFirstChild(){
        //Load the first subView
        self.slideMenuItemSelectedAtIndex(0)
    }
    
    //Set the image background of Menu (TableView Header)
    func setImageBackground(imageName:String){
        imageNameHeaderMenu=imageName
    }
    
    
}
