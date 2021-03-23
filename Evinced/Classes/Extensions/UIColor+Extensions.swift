//
//  UIColor+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

extension UIColor {
    
    //static colors
    static let evincedGreen = UIColor(red: 115/255, green: 195/255, blue: 192/255, alpha: 1)
    static let evincedGreenOp = UIColor(red: 115/255, green: 195/255, blue: 192/255, alpha: 0.5)
    static let evincedDark = UIColor.init(hex: "#ff73c3c0")!
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    var hexString: String { cgColor.hexString }
    
    static func contrastRatio(between color1: UIColor, and color2: UIColor) -> CGFloat {
        let luminance1 = color1.luminance()
        let luminance2 = color2.luminance()

        let luminanceDarker = min(luminance1, luminance2)
        let luminanceLighter = max(luminance1, luminance2)

        return (luminanceLighter + 0.05) / (luminanceDarker + 0.05)
    }

    func contrastRatio(with color: UIColor) -> CGFloat {
        return UIColor.contrastRatio(between: self, and: color)
    }

    func luminance() -> CGFloat {
        let ciColor = CIColor(color: self)

        func adjust(colorComponent: CGFloat) -> CGFloat {
            return (colorComponent < 0.04045) ? (colorComponent / 12.92) : pow((colorComponent + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * adjust(colorComponent: ciColor.red) + 0.7152 * adjust(colorComponent: ciColor.green) + 0.0722 * adjust(colorComponent: ciColor.blue)
    }
}

extension CGColor {
    
    var hexString: String {
        let cgColorInRGB = converted(to: CGColorSpace(name: CGColorSpace.sRGB)!,
                                     intent: .defaultIntent,
                                     options: nil)!
        
        let colorRef = cgColorInRGB.components ?? []
        let r = colorRef[0]
        let g = colorRef[1]
        let b = (colorRef.count > 2 ? colorRef[2] : g)

        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if alpha < 1 {
            color += String(format: "%02lX", lroundf(Float(alpha * 255)))
        }

        return color
    }
}

