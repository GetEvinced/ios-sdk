//
//  UIView+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

extension UIView {
    
    var globalPoint: CGRect? { return self.superview?.convert(self.frame, to: nil) }
    
    func accessibilityExposeGestures(target: Any?, selector: Selector?) {
        guard target != nil && selector != nil else { return }
        
        let action = UIAccessibilityCustomAction(name: selector!.description, target: target, selector: selector!)

        if var accActions = self.accessibilityCustomActions {
            accActions.append(action)
            self.accessibilityCustomActions = accActions
        } else {
            self.accessibilityCustomActions = [action]
        }
    }
    
    func evincedId() -> String {
        
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
    
    func imageAsStringAsync(jpeg: Bool = false, unclipped: Bool = false, completion: @escaping (String?) -> Void) {
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
    
    func imageAsString(jpeg: Bool = false) -> String? {
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
        
    func getMaxBounds() -> CGRect {
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

