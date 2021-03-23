//
//  AccessibilityEvent.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

struct AccessibilityEvent: Encodable {
    var type: MessageType = .accessibilityStatus
    let isEnabled: Bool
}
