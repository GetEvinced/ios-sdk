//
//  Logger.swift
//  Evinced
//
//  Created by Roy Zarchi on 31/08/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

class Logger: NSObject {
    
    static let shared = Logger()
    
    static var enabled = true;
    
    static func log(_ text: String) {
        if (enabled) {
            Logger.shared.log(text)
        }
    }
    
    private override init() {}
    
    var log = ["Evinced Log - Start"]
    
    var changed: (() -> ())?
    
    func log(_ text: String) {
        DispatchQueue.main.async {
            print(text)
            let date = Date()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let timestamp = formatter.string(from: date)
                        
            self.log.append("[\(timestamp)] \(text)")
            self.changed?()
        }
    }
    
    func clear() {
        log.removeAll()
        changed?()
    }
}
