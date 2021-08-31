//
//  SDKInfo.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

struct SDKInfo: Encodable {
    var type: MessageType = .sdkInfo
    let isEnabled: Bool
    let sdkVersion: String?
    let appName: String?
    let appDisplayName: String?
    let appBundle: String?
    let testEngineType: String
}

