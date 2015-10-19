# Swift-Slide-Menu (Material Design Inspired)
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

A Slide Menu, written in Swift 2, inspired by Navigation Drawer on Material Design (inspired by [Google Material Design](https://www.google.com/design/spec/patterns/navigation-drawer.html)) for iOS written in Swift 2.0

Please feel free to make pull requests :)

![alt tag](https://github.com/PhilippeBoisney/Swift-Slide-Menu/raw/master/SlideMenu.gif)

## USAGE
1. **Add those 5 files** on your project : BaseViewController.swift, ChildViewController.swift, MenuTableViewCell.swift, TableViewMenuController.swift and ZFRippleButton.swift. Don't forget to also add "background.jpg" on your asset directory.
2. **Add your own mini icons** for menu on your asset directory
3. Create **ViewControllers** Swift files for your **ChildView**, subclass with ChildViewController.
4. Create on **Storyboard** (Interface Builder) your **ChildViews** (Just drag UIViewController)then **set "Storyboard ID" AND "CustomClass"**
5. **Subclass** your main ViewController with BaseViewController and on Storyboard(Interface Builder), select your main ViewController, then **add a Navigation Controller** (Editor => Embed In => Navigation Controller).
6. Finally, Add on your main ViewController:
```swift
//Add the childViews
addChildView("HomeScreenID", titleOfChildren: "HOME", iconName: "home")
addChildView("ContactScreenID", titleOfChildren: "CONTACT", iconName: "contact")

//Show the first childScreen
showFirstChild()
```


## Version
1.2

## Features

- Multi-Device Full Support
- Rotation Support
- Material Design Effect

## Thanks
This library use a modified version of this awesome project: [ZFRippleButton](https://github.com/zoonooz/ZFRippleButton)

## Author

Philippe BOISNEY (phil.boisney(@)gmail.com)
