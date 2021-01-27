//
//  UIExtensions.swift
//  Evinced
//
//  Created by Alexandr Lambov on 26.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIColor {
    private enum Colors {
        static var darkGreen        = UIColor(hex: "#00615AFF")!
        static var neutral          = UIColor(hex: "#8C8C8CFF")!
        static var evincedTitle     = UIColor(hex: "#000000DA")!
        static var evincedLightGray = UIColor(hex: "#F6F6F6FF")!
        static var evincedGray      = UIColor(hex: "#D9D9D9FF")!
    }
    
    static var darkGreen: UIColor        { Colors.darkGreen }
    static var neutral: UIColor          { Colors.neutral }
    static var evincedTitle: UIColor     { Colors.evincedTitle }
    static var evincedLightGray: UIColor { Colors.evincedLightGray }
    static var evincedGray: UIColor      { Colors.evincedLightGray }
}

extension UILabel {
    static func titleLabel() -> UILabel {
        let titleLabel = UILabel()
        
        titleLabel.font = .boldSystemFont(ofSize: 20.0)
        titleLabel.textColor = .evincedTitle
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        return titleLabel
    }
}

extension UIButton {
    static func primaryButton() -> UIButton {
        let primaryButton = UIButton()
    
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.setTitleColor(.evincedLightGray, for: .highlighted)
        primaryButton.setBackgroundImage(UIImage(color: .darkGreen),
                                         for: .normal)
        primaryButton.setBackgroundImage(UIImage(color: .neutral),
                                         for: .disabled)
        
        
        primaryButton.layer.cornerRadius = 4.0
        primaryButton.clipsToBounds = true
        
        primaryButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        return primaryButton
    }
    
    static func secondaryButton() -> UIButton {
        let secondaryButton = UIButton()
    
        secondaryButton.setTitleColor(.darkGreen, for: .normal)
        secondaryButton.setTitleColor(.gray, for: .highlighted)
        
        let layer = secondaryButton.layer
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGreen.cgColor
        layer.cornerRadius = 4.0
        
        secondaryButton.clipsToBounds = true
        
        secondaryButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        
        return secondaryButton
    }
}
