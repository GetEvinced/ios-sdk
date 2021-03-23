//
//  ImageView.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class ImageView: View {
    var resizingMode: Int?
    var hasImage: Bool
    
    enum CodingKeys: String, CodingKey {
        case resizingMode
        case hasImage
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hasImage, forKey: .hasImage)
        try container.encode(resizingMode, forKey: .resizingMode)
        
        try super.encode(to: encoder)
    }
    
    init(imageView: UIImageView)  {
        resizingMode = imageView.image?.resizingMode.rawValue
        hasImage = imageView.image != nil
        
        super.init(view: imageView)
        
        ancestorType = .uiImageView
    }
}

