//
//  ZFRippleButton.swift
//  ZFRippleButtonDemo
//
//  Created by Amornchai Kanokpullwad on 6/26/14.
//  Copyright (c) 2014 zoonref. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class ZFRippleButton: UIButton {
    
    @IBInspectable var ripplePercent: Float = 1.5 {
        didSet {
            setupRippleView()
        }
    }
    
    @IBInspectable var rippleColor: UIColor = UIColor(white: 1, alpha: 0.5) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    
    @IBInspectable var rippleBackgroundColor: UIColor = UIColor.clear {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    
    @IBInspectable var buttonCornerRadius: Float = 0 {
        didSet{
            layer.cornerRadius = CGFloat(buttonCornerRadius)
        }
    }
    
    @IBInspectable var rippleOverBounds: Bool = true
    @IBInspectable var shadowRippleRadius: Float = 1
    @IBInspectable var shadowRippleEnable: Bool = false
    @IBInspectable var trackTouchLocation: Bool = false
    @IBInspectable var touchUpAnimationTime: Double = 0.6
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    
    private var tempShadowRadius: CGFloat = 0
    private var tempShadowOpacity: Float = 0
    private var touchCenterLocation: CGPoint?
    
    private var rippleMask: CAShapeLayer? {
        get {
            if !rippleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
                return maskLayer
            } else {
                return nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        layer.addSublayer(rippleBackgroundView.layer)
        rippleBackgroundView.layer.addSublayer(rippleView.layer)
        rippleBackgroundView.alpha = 0
    }
    
    private func setupRippleView() {
        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
        let x: CGFloat = (bounds.width / 2) - (size / 2)
        let y: CGFloat = (bounds.width / 2) - (size / 2)
        let corner: CGFloat = size / 2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
        rippleView.layer.cornerRadius = corner
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.location(in: self)
        } else {
            touchCenterLocation = nil
        }
        
        UIView.animate(withDuration: 0.1,
                                   animations: {
                                    self.rippleBackgroundView.alpha = 1
        }, completion: nil)
        
        rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut,
                                   animations: {
                                    self.rippleView.transform = .identity
        }, completion: nil)
        
        if shadowRippleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowOpacity = layer.shadowOpacity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = shadowRippleRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = 1
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            layer.add(groupAnim, forKey:"shadow")
        }
        return super.beginTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animateToNormal()
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animateToNormal()
    }
    
    private func animateToNormal() {
        UIView.animate(withDuration: 0.1,
                                   animations: {
                                    self.rippleBackgroundView.alpha = 1
        },
                                   completion: {(success: Bool) -> () in
                                    UIView.animate(withDuration: self.touchUpAnimationTime,
                                                               animations: {
                                                                self.rippleBackgroundView.alpha = 0
                                    }, completion: nil)
        }
        )
        
        UIView.animate(withDuration: 0.7, delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState],
                                   animations: {
                                    self.rippleView.transform = .identity
                                    
                                    let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
                                    shadowAnim.toValue = self.tempShadowRadius
                                    
                                    let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
                                    opacityAnim.toValue = self.tempShadowOpacity
                                    
                                    let groupAnim = CAAnimationGroup()
                                    groupAnim.duration = 0.7
                                    groupAnim.fillMode = kCAFillModeForwards
                                    groupAnim.isRemovedOnCompletion = false
                                    groupAnim.animations = [shadowAnim, opacityAnim]
                                    
                                    self.layer.add(groupAnim, forKey:"shadowBack")
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        
        rippleBackgroundView.layer.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }
    
}
