//
//  BaseViewController.swift
//  Swift Slide Menu
//
//  Created by Philippe BOISNEY 10/01/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    //Declaring our subView
    var homeSreenSubView: UIViewController!
    var contactSreenSubView: UIViewController!
    var loveSreenSubView: UIViewController!
    var settingsSreenSubView: UIViewController!
    var objMenu : TableViewMenuController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Implementing our subView
        homeSreenSubView = storyboard!.instantiateViewControllerWithIdentifier("HomeScreenID")
        contactSreenSubView = storyboard!.instantiateViewControllerWithIdentifier("ContactScreenID")
        loveSreenSubView = storyboard!.instantiateViewControllerWithIdentifier("LoveScreenID")
        settingsSreenSubView = storyboard!.instantiateViewControllerWithIdentifier("SettingsScreenID")
        
        //Show the SlideMenu and it's button
        self.addSlideMenuButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(index: Int32) {
        //print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            self.title="Home"
            transitionBetweenTwoViews(homeSreenSubView)
            break
        case 1:
            self.title="Contacts"
            transitionBetweenTwoViews(contactSreenSubView)
            break
        case 2:
            self.title="Love"
            transitionBetweenTwoViews(loveSreenSubView)
            break
        case 3:
            self.title="Settings"
            transitionBetweenTwoViews(settingsSreenSubView)
            break

        default:
            break
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
        btnShowMenu.addTarget(self, action: "onSlideMenuButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(27, 22), false, 0.0)
            
            UIBezierPath(rect: CGRectMake(0, 3, 27, 2)).fill()
            UIBezierPath(rect: CGRectMake(0, 10, 27, 2)).fill()
            UIBezierPath(rect: CGRectMake(0, 17, 27, 2)).fill()
            
            defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        })
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (sender.tag == 10)
        {
            // Menu is already displayed, no need to display it twice, otherwise we hide the menu
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenu : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var rectViewMenu : CGRect = viewMenu.frame
                rectViewMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
                viewMenu.frame = rectViewMenu
                viewMenu.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    viewMenu.removeFromSuperview()
            })
            
            //Remove Menu View Controller
            objMenu.willMoveToParentViewController(nil)
            objMenu.view.removeFromSuperview()
            objMenu.removeFromParentViewController()
            return
        }
        
        sender.enabled = false
        sender.tag = 10
        
        objMenu = TableViewMenuController()
        objMenu.btnMenu = sender
        objMenu.delegate = self
        self.view.addSubview(objMenu.view)
        self.addChildViewController(objMenu)
        objMenu.view.layoutIfNeeded()
        
        objMenu.createOrResizeMenuView()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.objMenu.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
            sender.enabled = true
            }, completion:nil)
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
    
    
}
