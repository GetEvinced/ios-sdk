//
//  NavigationBar.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class NavigationBar: View {
    init(navigationBar: UINavigationBar)  {
        super.init(view: navigationBar)
        
        ancestorType = .uiNavigationBar
    }
}
