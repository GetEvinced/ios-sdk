//
//  UIViewController+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

extension UIViewController {
    
    var evincedName: String {
        let name = title ?? String(describing: type(of: self))
        return !name.isEmpty ? name : "View Controller"
    }
    
    open func evincedId() -> String {
        var id = ""
        
        let vcClassName = String(describing: type(of: self))
        id += "classname=\(vcClassName)-"
        
        let restorationId = self.restorationIdentifier
        id += "resid=\(restorationId ?? "null")-"
        
        let storyboardId = self.storyboardId
        id += "sbid=\(storyboardId ?? "null")-"
        
        let nib = self.nibName
        id += "nib=\(nib ?? "null")"
        
        return id
    }
    
    var storyboardId: String? {
        return value(forKey: "storyboardIdentifier") as? String
    }
}
