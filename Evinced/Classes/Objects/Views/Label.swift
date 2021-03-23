//
//  Label.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class Label: View {
    var text: String?
    var color: String
    
    var fontSize: CGFloat
    var fontWeight: String // System will return this proprety capitalized
    
    
    enum CodingKeys: String, CodingKey {
        case text
        case color
        case fontSize
        case fontWeight
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(text, forKey: .text)
        try container.encode(color, forKey: .color)
        
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(fontWeight, forKey: .fontWeight)
        
        try super.encode(to: encoder)
    }
    
    init(label: UILabel)  {
        color = label.textColor.hexString
        text = label.text
        
        let font = label.font! // We could use `!` here
        
        fontSize = font.pointSize
        fontWeight = font.fontDescriptor.object(forKey: .face) as? String ?? ""
        
        super.init(view: label)
        
        ancestorType = .uiLabel
    }
}

