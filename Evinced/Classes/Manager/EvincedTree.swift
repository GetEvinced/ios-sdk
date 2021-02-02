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
        tree = createView(view: root, rootView: root)
    }
    
    func createView(view: UIView, rootView: UIView)  -> Codables.View {
        var result: Codables.View
        
        if (accessibilityLabel == "EVINCED_SKIP_RECURSIVE") {
            return Codables.View(view: view, rootView: rootView)
        }
        
        if let button = view as? UIButton {
            result = Codables.Button(button: button,
                                     rootView: rootView)
        }
        
        else if let slider = view as? UISlider {
            result = Codables.Slider(slider: slider,
                                     rootView: rootView)
        }
        
        else if let stepper = view as? UIStepper {
            result = Codables.Stepper(stepper: stepper,
                                     rootView: rootView)
        }
        
        else if #available(iOS 13, *),
                let searchField = view as? UISearchTextField {
            result = Codables.SearchTextField(searchTextField: searchField,
                                              rootView: rootView)
        }
        
        else if let textField = view as? UITextField {
            result = Codables.TextField(textField: textField,
                                          rootView: rootView)
        }
        
        else if let control = view as? UIControl {
            result = Codables.Control(control: control,
                                      rootView: rootView)
        }
        
        else if let searchBar = view as? UISearchBar {
            result = Codables.SearchBar(searchBar: searchBar,
                                        rootView: rootView)
        }
        
        else if let toolbar = view as? UIToolbar {
            result = Codables.Toolbar(toolbar: toolbar,
                                      rootView: rootView)
        }
        
        else if let tabBar = view as? UITabBar {
            result = Codables.TabBar(tabBar: tabBar,
                                     rootView: rootView)
        }
        
        else if let navigationBar = view as? UINavigationBar {
            result = Codables.NavigationBar(navigationBar: navigationBar,
                                            rootView: rootView)
        }
        
        else if let label = view as? UILabel {
            result = Codables.Label(label: label,
                                    rootView: rootView)
        }
            
        else if let imageView = view as? UIImageView {
            result = Codables.ImageView(imageView: imageView,
                                        rootView: rootView)
        }
        
        else {
            result = Codables.View(view: view,
                                   rootView: rootView)
        }
        
        result.children = view.subviews.map {
            createView(view: $0,
                       rootView: rootView)
        }
        
        return result
    }
}
