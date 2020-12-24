//
//  Locker.swift
//  Evinced
//
//  Created by Roy Zarchi on 19/08/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

class Locker: NSObject {
    
    static let shared = Locker()
    
    override private init() {}
    
    var ip: String? {
        return UserDefaults.standard.string(forKey: "evinced-desktop-addr")
    }
    
    func set(ip: String) {
        if validateIpAddress(ipToValidate: ip) {
          UserDefaults.standard.set(ip, forKey: "evinced-desktop-addr")
        }
    }
}
