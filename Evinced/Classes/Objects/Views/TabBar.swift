//
//  TabBar.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class TabBar: View {
    init(tabBar: UITabBar)  {
        super.init(view: tabBar)
        
        ancestorType = .uiTabBar
    }
}

