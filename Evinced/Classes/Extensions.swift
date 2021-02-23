//
//  Extensions.swift
//  Evinced
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation
import AVFoundation

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
        let cgColorInRGB = converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0

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

extension UIView {
    var globalPoint: CGRect? { return self.superview?.convert(self.frame, to: nil) }
    
    open func accessibilityExposeGestures(target: Any?, selector: Selector?) {
        guard target != nil && selector != nil else { return }
        
        let action = UIAccessibilityCustomAction(name: selector!.description, target: target, selector: selector!)

        if var accActions = self.accessibilityCustomActions {
            accActions.append(action)
            self.accessibilityCustomActions = accActions
        } else {
            self.accessibilityCustomActions = [action]
        }
        
        
//        let handlers = self.gestureRecognizers
//
//        if let handlers = handlers {
//            for handler in handlers {
//
//            }
//        }
    }
    
    open func evincedId() -> String {
        
        var id = ""
        
        if let vc = self.findViewController() {
            
            // Parent view controller name
            id += "\(NSStringFromClass(vc.classForCoder).split(separator: ".").last!)-"
            
            // view type
            id += "\(String(describing: type(of: self)))-"
            
            // list of indexes for view in its super view, recursive up to the view-controller's view
            func indexInParent(view: UIView) {
                if let superview = view.superview {
                    if let index = superview.subviews.firstIndex(of: view) {
                        id += "\(index)-"
                    }
                    
                    if superview != vc.view {
                        indexInParent(view: superview)
                    }
                }
            }
            
            indexInParent(view: self)
        }
        
        id += "EVINCED"
        return id
    }
    
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    public func imageAsStringAsync(jpeg: Bool = false, unclipped: Bool = false, completion: @escaping (String?) -> Void) {
        let bounds = unclipped ? self.getMaxBounds() : self.bounds
        self.layer.masksToBounds = false
        let layer = self.layer
        var img: String? = nil
        
        func fetchImg() {
            DispatchQueue.global(qos: .userInteractive).async {
                func generateImage() -> String? {
                    let renderer = UIGraphicsImageRenderer(bounds: bounds)
                    
                    if jpeg {
                        // Return image as JPEG
                        return renderer.jpegData(withCompressionQuality: 0.3) { rendererContext in
                            layer.render(in: rendererContext.cgContext)
                        }.base64EncodedString()
                    } else {
                        // Return image as PNG
                        return renderer.image { rendererContext in
                            layer.render(in: rendererContext.cgContext)
                        }.cgImage?.png?.base64EncodedString()
                    }
                }
                
                img = generateImage()
                
                DispatchQueue.main.async {
                    completion(img)
                }
            }
        }
        
        if unclipped {
            self.disableClippingAndRun {
                fetchImg()
            }
        } else {
            fetchImg()
        }
    }
    
    public func imageAsString(jpeg: Bool = false) -> String? {
        let bounds = self.bounds
        self.layer.masksToBounds = false
        let layer = self.layer
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        if jpeg {
            // Return image as JPEG
            return renderer.jpegData(withCompressionQuality: 0.3) { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }.base64EncodedString()
        } else {
            // Return image as PNG
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }.cgImage?.png?.base64EncodedString()
        }
    }
    
    func disableClippingAndRun(completion: () -> Void) {
        var originallyClippedViews: [UIView] = []
            
        func disableClipping() {
            func iterate(view: UIView) {
                
                // Save all the clipped views so after we take the image we change them back
                if view.clipsToBounds == true {
                    originallyClippedViews.append(view)
                }
    
                // set all to false
                view.clipsToBounds = false
                
                for subview in view.subviews {
                    iterate(view: subview)
                }
            }
            
            iterate(view: self)
        }
        
        disableClipping()
        
        completion()
        
        // set it all back how it was
        for view in originallyClippedViews {
            view.clipsToBounds = true
        }
    }
    
    func playVoiceOver() {
        var traits: [String] = []
        if self.accessibilityTraits.contains(.button) { traits.append("Button") }
        if self.accessibilityTraits.contains(.image) { traits.append("Image") }
        if self.accessibilityTraits.contains(.tabBar) { traits.append("tabBar") }
        if self.accessibilityTraits.contains(.selected) { traits.append("selected") }
        
        let speechsynth = AVSpeechSynthesizer()
        let message = "\(self.accessibilityLabel ?? "Unknown"), \(traits.joined(separator: ", "))"
        let utterance = AVSpeechUtterance.init(string: message)
        speechsynth.speak(utterance)
    }
        
    public func getMaxBounds() -> CGRect {
        var width = self.bounds.width
        var height = self.bounds.height
        
        func iterate(view: UIView) {
            width = max(view.bounds.width, width)
            height = max(view.bounds.height, height)
            
            for subview in view.subviews {
                iterate(view: subview)
            }
        }
        
        iterate(view: self)
                
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
}

extension UIViewController {
    var evincedName: String {
        var name = "View Controller"
        if let title = self.title {
            name = title
        } else {
            let desc = String(describing: type(of: self))
            if desc.count > 0 {
                name = desc
            }
        }
        
        return name
    }
    
    open func evincedId() -> String {
        var id = ""
        
        let vcClassName = String(describing: type(of: self))
        id += "classname=\(vcClassName)-"
        
        let restorationId = self.restorationIdentifier
        id += "resid=\(restorationId ?? "null")-"
        
        let storyboardId = self.storyboardId
        id += "sbid=\(storyboardId ?? "null")-"
        
        let nib = self.nibName
        id += "nib=\(nib ?? "null")"
        
        return id
    }
    
    fileprivate var storyboardId: String? {
        return value(forKey: "storyboardIdentifier") as? String
    }
}

extension UIImage {
    class func bundledImage(named: String) -> UIImage? {
        guard let image = UIImage(named: named) else {
            return UIImage(named: named,
                           in: Bundle(for: EvincedEngine.classForCoder()),
                           compatibleWith: nil)
        }
        return image
    }

}


extension CGImage {
    var png: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
    
    var averageColor: UIColor? {
        let inputImage = CIImage(cgImage: self)
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension String: Error {}
