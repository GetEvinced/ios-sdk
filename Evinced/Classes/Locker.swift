//
//  Locker.swift
//  EvincedSDKiOS
//
//  Copyright © 2020 IEvinced, Inc. All rights reserved.
//

import Foundation

class Locker: NSObject {
    
    static let shared = Locker()
    
    override private init() {}
    
    var socketUrl: URL? {
        get {
            let socketUrl = UserDefaults.standard.url(forKey: "evinced-desktop-url")
            guard (socketUrl?.port ?? 0) <= UInt16.max else { return nil }
            return socketUrl
        }
        set { UserDefaults.standard.set(newValue, forKey: "evinced-desktop-url") }
    }
}
