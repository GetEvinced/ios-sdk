//
//  Tree.swift
//  EvincedSDKiOS
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation

class EvincedTree: NSObject {
    var tree: View?
    
    init(root: UIView) {
        super.init()
        tree = createView(view: root)
    }
    
    func createView(view: UIView)  -> View {
        var result: View
        
        if (accessibilityLabel == "EVINCED_SKIP_RECURSIVE") {
            return View(view: view)
        }
        
        if let button = view as? UIButton {
            result = Button(button: button)
        }
        
        else if let slider = view as? UISlider {
            result = Slider(slider: slider)
        }
        
        else if let stepper = view as? UIStepper {
            result = Stepper(stepper: stepper)
        }
        
        else if #available(iOS 13, *),
                let searchField = view as? UISearchTextField {
            result = SearchTextField(searchTextField: searchField)
        }
        
        else if let textField = view as? UITextField {
            result = TextField(textField: textField)
        }
        
        else if let control = view as? UIControl {
            result = Control(control: control)
        }
        
        else if let searchBar = view as? UISearchBar {
            result = SearchBar(searchBar: searchBar)
        }
        
        else if let toolbar = view as? UIToolbar {
            result = Toolbar(toolbar: toolbar)
        }
        
        else if let tabBar = view as? UITabBar {
            result = TabBar(tabBar: tabBar)
        }
        
        else if let navigationBar = view as? UINavigationBar {
            result = NavigationBar(navigationBar: navigationBar)
        }
        
        else if let label = view as? UILabel {
            result = Label(label: label)
        }
            
        else if let imageView = view as? UIImageView {
            result = ImageView(imageView: imageView)
        }
        
        else {
            result = View(view: view)
        }
        
        result.children = view.subviews.map {
            createView(view: $0)
        }
        
        return result
    }
}
