//
//  Toolbar.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class Toolbar: View {
    init(toolbar: UIToolbar)  {
        super.init(view: toolbar)
        
        ancestorType = .uiToolbar
    }
}
