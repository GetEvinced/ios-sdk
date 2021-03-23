//
//  Manager.swift
//  EvincedSDKiOS
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation
import Starscream

class Manager {
    static let shared = Manager()
    
    var enableShake = true
    
    func sendFullReport(_ fullReport: FullReport, completed: (() -> ())? = nil) {
        Logger.log("Sending full report")
        
        let reportString = fullReport.stringify() ?? "parsing error"
        Socket.shared.send(message: reportString, completed: completed)
    }
}
