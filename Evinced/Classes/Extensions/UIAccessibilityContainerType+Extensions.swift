//
//  UIAccessibilityContainerType+Extensions.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

enum AccessibilityContainerType: String, Encodable {
    case none
    case dataTable
    case list
    case landmark
    case semanticGroup
    case unknown
}

extension UIAccessibilityContainerType {
    var sdkType: AccessibilityContainerType {
        switch self {
        case .none:
            return .none
        case .dataTable:
            return .dataTable
        case .list:
            return .list
        case .landmark:
            return .landmark
        case .semanticGroup:
            return.semanticGroup
        @unknown default:
            return .unknown
        }
    }
}
