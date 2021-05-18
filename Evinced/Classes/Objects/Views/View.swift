//
//  View.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class View: Encodable {
    
    let instanceId: String
    let id: String
    
    let isViewControllerRoot: Bool
    let viewControllerName: String?
    
    var ancestorType: AncestorType = .uiView
    let classType: String
    
    let backgroundColor: String?
    let borderColor: String?
    let borderWidth: CGFloat
    
    let isAccessibilityElement: Bool
    let accessibilityLabel: String?
    let accessibilityIdentifier: String?
    let accessibilityTraits: [String]?
    let accessibilityIgnoresInvertColors: Bool
    let accessibilityFrame: NamedCGRect
    let accessibilityHint: String?
    let accessibilityElementsHidden: Bool
    let accessibilityViewIsModal: Bool
    
    let accessibilityElementCount: Int
    let accessibilityContainerType: AccessibilityContainerType
    let accessibilityElements: [AccessibilityElement]?

    let clipsToBounds: Bool
    let isHidden: Bool
    let isOpaque: Bool
    let isFocused: Bool
    let isUserInteractionEnabled: Bool
    let frame: NamedCGRect
    let bounds: NamedCGRect
    let opacity: CGFloat
    let gestureRecognizers: [GestureRecognizer]
    var children: [View] = []
    
    init(view: UIView) {
        instanceId = UUID().uuidString
        id = view.evincedId()
        isViewControllerRoot = view.findViewController()?.view == view
        viewControllerName = view.findViewController()?.evincedName
        classType = String(describing: type(of: view))
        
        frame = view.frame.namedCgRect
        bounds = view.bounds.namedCgRect
        
        backgroundColor = view.backgroundColor?.hexString
        borderColor = view.layer.borderColor?.hexString
        borderWidth = view.layer.borderWidth
        
        accessibilityLabel = view.accessibilityLabel
        accessibilityIdentifier = view.accessibilityIdentifier
        accessibilityTraits = view.accessibilityTraits.sdkTraits
        
        gestureRecognizers = view.gestureRecognizers?.map ({
            GestureRecognizer(
                name: $0.name,
                cancelsTouchesInView: $0.cancelsTouchesInView,
                isEnabled: $0.isEnabled,
                locationInView: $0.location(in: view))
        }) ?? []
        
        opacity = view.alpha
        clipsToBounds = view.clipsToBounds
        isAccessibilityElement = view.isAccessibilityElement
        accessibilityIgnoresInvertColors = view.accessibilityIgnoresInvertColors
        accessibilityFrame = view.accessibilityFrame.namedCgRect
        accessibilityHint = view.accessibilityHint
        accessibilityElementsHidden = view.accessibilityElementsHidden
        
        if #available(iOS 14, *) {
            //Fixing iOS 14 undocumented behavior
            accessibilityElementCount = view.accessibilityElementCount() == Int.max ? 0 : view.accessibilityElementCount()
        } else {
            accessibilityElementCount = view.accessibilityElementCount()
        }
        
        accessibilityContainerType = view.accessibilityContainerType.sdkType
        
        let viewId = id
        accessibilityElements = view.accessibilityElements?.enumerated()
            .compactMap {
                guard let element = $0.element as? UIAccessibilityElement else { return nil }
                return AccessibilityElement(with: element,
                                            viewId: viewId,
                                            index: $0.offset)
            }
        
        isUserInteractionEnabled = view.isUserInteractionEnabled
        isHidden = view.isHidden
        isOpaque = view.isOpaque
        isFocused = view.isFocused
        accessibilityViewIsModal = view.accessibilityViewIsModal
    }
}


struct GestureRecognizer: Encodable {
    let name: String?
    let cancelsTouchesInView: Bool
    let isEnabled: Bool
    let locationInView: CGPoint
}

struct AccessibilityElement: Encodable {
    
    let instanceId: String
    let id: String
    
    let accessibilityIdentifier: String?
    let accessibilityLabel: String?
    let accessibilityHint: String?
    let accessibilityValue: String?
    let accessibilityFrame: NamedCGRect
    let accessibilityFrameInContainerSpace: NamedCGRect
    let accessibilityViewIsModal: Bool
    let accessibilityTraits: [String]?
    
    init(with element: UIAccessibilityElement, viewId: String, index: Int) {
        instanceId = UUID().uuidString
        id = "\(viewId)-ACCESSIBILITY_ELEMENT-\(index)"
        
        accessibilityIdentifier = element.accessibilityIdentifier
        accessibilityLabel = element.accessibilityLabel
        accessibilityHint = element.accessibilityHint
        accessibilityValue = element.accessibilityValue
        accessibilityFrame = element.accessibilityFrame.namedCgRect
        accessibilityViewIsModal = element.accessibilityViewIsModal
        accessibilityFrameInContainerSpace = element.accessibilityFrameInContainerSpace.namedCgRect
        accessibilityTraits = element.accessibilityTraits.sdkTraits
    }
}
