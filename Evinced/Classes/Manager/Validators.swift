//
//  Validators.swift
//  Evinced
//
//  Created by Roy Zarchi on 17/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation
import UIKit

public class Validator: NSObject {
    class Button: NSObject {
        class AccLabel: NSObject {
            class func isDerivedFromIcon(button: UIButton) -> Bool {
                if Validator.labelMissing(view: button) { return false }
                
                var labels = [String?]()
            
                labels.append(edit(string: button.currentBackgroundImage?.accessibilityIdentifier))
                labels.append(edit(string: button.imageView?.accessibilityIdentifier))
                
                labels.append(edit(string: button.image(for: .normal)?.accessibilityIdentifier))
                labels.append(edit(string: button.image(for: .application)?.accessibilityIdentifier))
                labels.append(edit(string: button.image(for: .disabled)?.accessibilityIdentifier))
                labels.append(edit(string: button.image(for: .focused)?.accessibilityIdentifier))
                labels.append(edit(string: button.image(for: .highlighted)?.accessibilityIdentifier))
                labels.append(edit(string: button.image(for: .reserved)?.accessibilityIdentifier))
                labels.append(edit(string: button.image(for: .selected)?.accessibilityIdentifier))
                
                return labels.contains(button.accessibilityLabel)
            }
        }
    }
    
    class func isClickable(view: UIView) -> Bool {
        return view.gestureRecognizers?.count ?? 0 > 0
    }
    
    class func labelMissing(view: UIView) -> Bool {
        return (view.accessibilityLabel == nil || view.accessibilityLabel!.count < 1)
    }
    
    class func accessible(view: UIView) -> Bool {
        return view.isAccessibilityElement
    }
 
    class func enabled(view: UIView) -> Bool {
        return view.isUserInteractionEnabled
    }
    
    class func visible(view: UIView) -> Bool {
        return view.alpha > 0.1
    }
    
    class func hasTrait(view: UIView, trait: UIAccessibilityTraits) -> Bool {
        return view.accessibilityTraits.contains(trait)
    }
    
    class func equalType(view: UIView, isExactlySameTypeAs: String) -> Bool {
        let className = String(describing: type(of: view))
        return className == isExactlySameTypeAs
    }

}
func edit(string: String?) -> String? {
    return string?.replacingOccurrences(of: "-", with: " ")
}

let allTraits: [String: UIAccessibilityTraits] =
    [
        "adjustаble": .adjustable,
        "allowsDirectInteraction": .allowsDirectInteraction,
        "button": .button,
        "causesPageTurn": .causesPageTurn,
        "header": .header,
        "image": .image,
        "keyboardKey": .keyboardKey,
        "link": .link,
        "none": .none,
        "notEnabled": .notEnabled,
        "playsSound": .playsSound,
        "searchField": .searchField,
        "selected": .selected,
        "startsMediaSession": .startsMediaSession,
        "staticText": .staticText,
        "summaryElement": .summaryElement,
        "tabBar": .tabBar,
        "updatesFrequently": .updatesFrequently
    ]
