//
//  Validators.swift
//  InAppViewDebugger
//
//  Created by Roy Zarchi on 13/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

class UIEvincedMarker: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    func initView() {
        self.accessibilityIdentifier = "EVINCED_VIEW_OVERLAY"
        
        self.alpha = 0.5
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemRed.cgColor
        self.backgroundColor = UIColor.systemRed
        self.addShadow(color: UIColor.systemRed)
    }
    
    func show() {
        self.alpha = 0.5
    }
    
    func hide() {
        self.alpha = 0
    }
    
    func addSelfTo(view: UIView) {
        
        for subview in view.subviews {
            if subview is UIEvincedMarker {
                subview.removeFromSuperview()
            }
        }
        
        view.insertSubview(self, at: 0)
        
        self.isUserInteractionEnabled = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func remove() {
        self.removeFromSuperview()
    }
    
    private func addShadow(color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
    }
    
    func set(color: UIColor) {
        addShadow(color: color)
        self.backgroundColor = color
    }
}
