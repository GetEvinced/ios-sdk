//
//  MessageType.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

enum MessageType: String, Encodable {
    case sdkInfo = "sdk_info"
    case accessibilityStatus = "a11y_enabled"
    case fullReport = "full_report"
    case reportPatch = "report_patch"
}
