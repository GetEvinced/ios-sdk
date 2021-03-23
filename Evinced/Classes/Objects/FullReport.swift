//
//  FullReport.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

struct FullReport: Encodable {
    var type: MessageType = .fullReport
    let tree: View?
    let snapshot: String?
    let appName: String?
}
