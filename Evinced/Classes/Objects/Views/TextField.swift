//
//  TextField.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class TextField: Control {
    init(textField: UITextField)  {
        super.init(control: textField)
        
        ancestorType = .uiTextField
    }
}
