//
//  Utils.swift
//  Evinced
//
//  Created by Roy Zarchi on 23/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

struct JSONStringEncoder {
    /**
     Encodes a dictionary into a JSON string.
     - parameter dictionary: Dictionary to use to encode JSON string.
     - returns: A JSON string. `nil`, when encoding failed.
     */
    static func encode(_ dictionary: [String: Any]) -> String? {
        guard JSONSerialization.isValidJSONObject(dictionary) else {
            assertionFailure("Invalid json object received.")
            return nil
        }

        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let jsonData: Data

        dictionary.forEach { (arg) in
            jsonObject.setValue(arg.value, forKey: arg.key)
        }

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
        } catch {
            assertionFailure("JSON data creation failed with error: \(error).")
            return nil
        }

        guard let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) else {
            assertionFailure("JSON string creation failed.")
            return nil
        }

        return jsonString
    }
    
    static func decode(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

class Utils {
    class Snapshot {
        class func snapshotVisualEffectBackdropView(_ view: UIView) -> CGImage? {
            guard let window = view.window else {
                return nil
            }
            var hiddenViews = [UIView]()
            defer {
                hiddenViews.forEach { $0.isHidden = false }
            }
            // UIVisualEffectView is a special case that cannot be snapshotted
            // the same way as any other view. From Apple docs:
            //
            //   Many effects require support from the window that hosts the
            //   UIVisualEffectView. Attempting to take a snapshot of only the
            //   UIVisualEffectView will result in a snapshot that does not
            //   contain the effect. To take a snapshot of a view hierarchy
            //   that contains a UIVisualEffectView, you must take a snapshot
            //   of the entire UIWindow or UIScreen that contains it.
            //
            // To snapshot this view, we traverse the view hierarchy starting
            // from the window and hide any views that are on top of the
            // _UIVisualEffectBackdropView so that it is visible in a snapshot
            // of the window. We then take a snapshot of the window and crop
            // it to the part that contains the backdrop view. This appears to
            // be the same technique that Xcode's own view debugger uses to
            // snapshot visual effect views.
            if hideViewsOnTopOf(view: view, root: window, hiddenViews: &hiddenViews) {
                let image = drawView(window)
                let cropRect = window.convert(view.bounds, from: view)
                return image?.cropping(to: cropRect)
            }
            return nil
        }

        class func drawView(_ view: UIView, bounds: CGRect? = nil) -> CGImage? {
            UIGraphicsBeginImageContextWithOptions(bounds?.size ?? view.bounds.size, false, 0)
            view.drawHierarchy(in: bounds ?? view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image?.cgImage
        }

        fileprivate class func hideViewsOnTopOf(view: UIView, root: UIView, hiddenViews: inout [UIView]) -> Bool {
            if root == view {
                return true
            }
            var foundView = false
            for subview in root.subviews.reversed() {
                if hideViewsOnTopOf(view: view, root: subview, hiddenViews: &hiddenViews) {
                    foundView = true
                    break
                }
            }
            if !foundView {
                if !root.isHidden {
                    hiddenViews.append(root)
                }
                root.isHidden = true
            }
            return foundView
        }
    }
}

func validSocketUrl(_ urlString: String) -> URL? {
    guard let url = URL(string: urlString),
          url.scheme == "ws" else { return nil }
    return url
}

func getVersion() -> String? {
    // using some file in the sdk to get the bundle
    let bundle = Bundle(for: type(of: Socket.shared))
    
    let versionNumber = bundle.infoDictionary?["CFBundleShortVersionString"] as! String
    let buildNumber = bundle.infoDictionary?["CFBundleVersion"] as! String
    
    return "\(versionNumber) (Build \(buildNumber))"
}
