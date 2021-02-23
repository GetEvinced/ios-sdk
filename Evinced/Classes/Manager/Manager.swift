//
//  Manager.swift
//  Evinced
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation
import Starscream

class Manager: SocketDelegate {
    static let shared = Manager()
    
    var enableShake = true
    
    var fullReport: Codables.FullReport?
    var previousFullReport: Codables.FullReport?
    
    private init() {
        Socket.shared.delegates.append(self)
    }
    
    func socket(event: WebSocketEvent) {
        switch event {
        case .connected(_):
            break
        case .disconnected, .error, .cancelled:
            fullReport = nil
            previousFullReport = nil
            break
        default:
            break
        }
    }
    
    func clear() {
        fullReport = nil
        previousFullReport = nil
    }
    
    func updateServer(completed: (() -> ())?) {
        Logger.log("Sending full report")
        sendFullReport(completed: completed)
    }
    
    func sendFullReport(completed: (() -> ())?) {
        previousFullReport = fullReport
        Socket.shared.send(message: fullReport?.stringify() ?? "parsing error", completed: completed)
    }
}
