//
//  MenuViewController.swift
//  Swift Slide Menu
//
//  Created by Philippe BOISNEY on 10/01/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32)
}

class TableViewMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableViewMenu : UITableView!
    var btnCloseTableViewMenu : UIButton!
    var arrayMenu = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    var nameOfImage: String!
    var backgroundImage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting TableView
        configureTableView()
        
        //Load Constraints
        applyConstraintsAndViews()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatearrayMenu()
    }
    
    override func viewDidLayoutSubviews() {
        //Resize MenuView when orientation change
        createOrResizeMenuView()
    }
    
    func updatearrayMenu(){
        tableViewMenu.reloadData()
    }
    
    //MARK: Animations
    func animateWhenViewAppear(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.btnCloseTableViewMenu.alpha = 0.3
            self.tableViewMenu.frame = CGRect(x: self.tableViewMenu.bounds.size.width, y: 0, width: self.tableViewMenu.bounds.size.width, height: self.tableViewMenu.bounds.size.height)
            self.tableViewMenu.layoutIfNeeded()
            }, completion: nil)
    }
    
    func animateWhenViewDisappear(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.btnCloseTableViewMenu.alpha = 0.0
            self.tableViewMenu.frame = CGRect(x: -self.tableViewMenu.bounds.size.width, y: 0, width: self.tableViewMenu.bounds.size.width, height: self.tableViewMenu.bounds.size.height)
            self.tableViewMenu.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    //MARK: Method call when user touch btnCloseTableViewMenu (Background)
    
    @objc func onCloseMenuClick(button:UIButton!){
        btnMenu.tag = 0
        //var  animationSpeed : CGFloat = 0.3
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseTableViewMenu){
                //animationSpeed = 0.3
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index: index)
        }
        
        animateWhenViewDisappear()
    }
    
    //MARK: Configure Table View
    
    func configureTableView(){
        
        tableViewMenu = UITableView(frame: view.bounds)
        tableViewMenu.dataSource = self
        tableViewMenu.delegate = self
        tableViewMenu.separatorStyle = .none
        tableViewMenu.register(MenuTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViewMenu.tableFooterView = UIView()
        tableViewMenu.clipsToBounds = false
        tableViewMenu.layer.masksToBounds = false
        tableViewMenu.layer.shadowColor = UIColor.black.cgColor
        tableViewMenu.layer.shadowOffset = CGSize(width: 1, height: 0)
        tableViewMenu.layer.shadowOpacity = 0.1
        tableViewMenu.layer.shadowRadius = 3
        
        view.addSubview(tableViewMenu)
    }
    
    //MARK: - Table View Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewMenu.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! MenuTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        cell.img.image = UIImage(named: arrayMenu[indexPath.row]["icon"]!)
        cell.label.text = arrayMenu[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(button: btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/10
    }
    
    //MARK: - Those two methods are used for image on header tableView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height/3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let imageToUse: UIImage = UIImage(named: nameOfImage)!
        let imageViewToUse: UIImageView = UIImageView(image: imageToUse)
        
        return imageViewToUse
    }
    
    //MARK: - This method is for resizing menu (Landscape/Portrait)
    
    func createOrResizeMenuView () {
        
        let widthPercentage:CGFloat
        
        if UIDevice.current.orientation.isLandscape {
            widthPercentage = 0.4 //Purcentage applied when orientation is Landscape
        } else {
            widthPercentage = 0.8 //Purcentage applied when orientation is Landscape
        }
        
        var newFrame: CGRect = self.view.frame;
        newFrame.size.height = self.view.frame.size.height
        newFrame.size.width = (self.view.frame.size.width) * widthPercentage
        
        self.tableViewMenu.frame = newFrame
        
        //Set Table View under TopLayoutGuide
//        let topLayoutGuide: CGFloat = self.topLayoutGuide.length
//        tableViewMenu.contentInset = UIEdgeInsetsMake(topLayoutGuide, 0, 0, 0)
        
    }
    
    //MARK: This Method is used for autolayout constraint
    
    func applyConstraintsAndViews(){
        
        //*** START Constraints for btnCloseTableViewMenu ***
        
        //Create Button View
        btnCloseTableViewMenu = UIButton()
        btnCloseTableViewMenu.backgroundColor=UIColor.black
        btnCloseTableViewMenu.alpha=0.0
        btnCloseTableViewMenu.translatesAutoresizingMaskIntoConstraints = false
        btnCloseTableViewMenu.addTarget(self, action: #selector(onCloseMenuClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnCloseTableViewMenu)
        self.view.sendSubview(toBack: btnCloseTableViewMenu)
        
        
        //Horizontal and Vertical Constraints
        let horizontalConstraint = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute:NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        //Height and Width Constraints
        let widthConstraintForButton = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let heightConstraintForButton = NSLayoutConstraint(item: btnCloseTableViewMenu, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        
        
        //Applying constraints
        self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraintForButton, heightConstraintForButton])
        
        //*** END Constraints for btnCloseTableViewMenu ***
    }
    
    //MARK: Methods for modify MenuView properties
    
    //Update menu tableView
    func setMenu (newMenu: [Dictionary<String,String>]){
        arrayMenu = newMenu
    }
    
    //Update Image of Header
    func setImageName(newName: String){
        nameOfImage=newName
    }
    
}
