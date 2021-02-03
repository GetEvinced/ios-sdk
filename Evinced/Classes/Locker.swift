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
    
    var socketUrl: URL? {
        get { UserDefaults.standard.url(forKey: "evinced-desktop-url") }
        set { UserDefaults.standard.set(newValue, forKey: "evinced-desktop-url") }
    }
}
