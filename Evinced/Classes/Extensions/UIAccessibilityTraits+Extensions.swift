//
//  UIAccessibilityTraits+Extensions.swift
//  Pods
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

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


extension UIAccessibilityTraits {
    var sdkTraits: [String] {
        allTraits
            .filter { contains($0.value) }
            .map { $0.key }
    }
}
