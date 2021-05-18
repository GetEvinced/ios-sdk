//
//  Logger.swift
//  EvincedSDKiOS
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation

class Logger: NSObject {
    
    static var isEnabled = true;
    
    static func log(_ text: String) {
        if (isEnabled) {
            DispatchQueue.main.async {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                let timestamp = formatter.string(from: Date())
                
                print("[Evinced][\(timestamp)] \(text)")
            }
        }
    }
    
    private override init() {}
}
