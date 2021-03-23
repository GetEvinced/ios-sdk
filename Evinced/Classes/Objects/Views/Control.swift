//
//  Control.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class Control: View {
    var states: [State]
    
    enum CodingKeys: String, CodingKey {
        case states
    }
    
    enum State: String, Encodable {
        case application
        case disabled
        case focused
        case highlighted
        case normal
        case reserved
        case selected
    }
    
    init(control: UIControl)  {
        states = control.state.sdkStates
        
        super.init(view: control)
        
        ancestorType = .uiControl
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(states, forKey: .states)
        
        try super.encode(to: encoder)
    }
}

extension UIControl.State {
    var sdkStates: [Control.State] {
        var sdkStates: [Control.State] = []
        
        if contains(.application) { sdkStates.append(.application) }
        if contains(.disabled)    { sdkStates.append(.disabled) }
        if contains(.focused)     { sdkStates.append(.focused) }
        if contains(.highlighted) { sdkStates.append(.highlighted) }
        if contains(.normal)      { sdkStates.append(.application) }
        if contains(.reserved)    { sdkStates.append(.reserved) }
        if contains(.selected)    { sdkStates.append(.selected) }
        
        return sdkStates
    }
}
