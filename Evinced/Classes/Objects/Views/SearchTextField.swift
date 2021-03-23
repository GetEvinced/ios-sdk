//
//  SearchTextField.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class SearchTextField: TextField {
    init(searchTextField: UITextField)  {
        super.init(textField: searchTextField)
        
        ancestorType = .uiSearchTextField
    }
}
