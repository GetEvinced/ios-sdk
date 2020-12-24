//
//  Tree.swift
//  Evinced
//
//  Created by Roy Zarchi on 30/09/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

class EvincedTree: NSObject {
    var tree: Codables.View?
    
    init(root: UIView) {
        super.init()
        tree = createView(view: root)
    }
    
    func createView(view: UIView) -> Codables.View {
        var result: Codables.View
        
        if (accessibilityLabel == "EVINCED_SKIP_RECURSIVE") {
            return Codables.View(view: view)
        }
        
        if view.isKind(of: UIButton.self) {
            result = Codables.Button(button: view as! UIButton)
        }
        
        else if view.isKind(of: UILabel.self) {
            result = Codables.Label(label: view as! UILabel)
        }
            
        else if view.isKind(of: UIImageView.self) {
            result = Codables.ImageView(imageView: view as! UIImageView)
        }
        
        else {
            result = Codables.View(view: view)
        }
        
        result.children = view.subviews.map({ createView(view: $0) })
        
        return result
    }
}
