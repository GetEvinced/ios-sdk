//
//  View.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class View: Encodable {
    var instanceId: String
    var id: String
    
    var isViewControllerRoot: Bool
    var viewControllerName: String?
    
    var ancestorType: AncestorType = .uiView
    var classType: String
    
    var backgroundColor: String?
    var borderColor: String?
    var borderWidth: CGFloat
    
    var isAccessibilityElement: Bool
    var accessibilityLabel: String?
    var accessibilityIdentifier: String?
    var accessibilityTraits: [String]?
    var accessibilityIgnoresInvertColors: Bool
    var accessibilityFrame: NamedCGRect
    var accessibilityHint: String?
    var accessibilityElementsHidden: Bool
    var accessibilityViewIsModal: Bool

    var clipsToBounds: Bool
    var isHidden: Bool
    var isOpaque: Bool
    var isFocused: Bool
    var isUserInteractionEnabled: Bool
    var frame: NamedCGRect
    var bounds: NamedCGRect
    var opacity: CGFloat
    var gestureRecognizers: [GestureRecognizer] = []
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
        accessibilityTraits = allTraits
            .filter({view.accessibilityTraits.contains($0.value)})
            .map({$0.key})
        
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

private let allTraits: [String: UIAccessibilityTraits] =
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
