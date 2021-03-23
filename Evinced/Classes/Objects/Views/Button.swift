//
//  Button.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class Button: Control {
    var color: String
    var text: String?
    var iconName: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case color
        case iconName
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(text, forKey: .text)
        try container.encode(color, forKey: .color)
        try container.encode(iconName, forKey: .iconName)
        
        try super.encode(to: encoder)
    }
    
    init(button: UIButton)  {
        color = button.currentTitleColor.hexString
        text = button.title(for: button.state)
        
        iconName = button.image(for: button.state)?.accessibilityIdentifier
        
        super.init(control: button)
        
        ancestorType = .uiButton
    }
}
