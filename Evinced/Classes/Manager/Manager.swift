//
//  Manager.swift
//  Evinced
//
//  Created by Roy Zarchi on 22/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

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
        if fullReport != nil {
            Logger.log("Sending patch")
            sendPatch(completed: completed)
        } else {
            Logger.log("Sending full report")
            sendFullReport(completed: completed)
        }
    }
    
    func sendFullReport(completed: (() -> ())?) {
        previousFullReport = fullReport
        Socket.shared.send(message: fullReport?.stringify() ?? "parsing error", completed: completed)
    }
    
    func sendPatch(completed: (() -> ())?) {
        do {
            if fullReport == nil { throw "Error" }
            let patch = try JSONPatch.createPatch(from: previousFullReport, to: fullReport)

            let reportPatch = Codables.ReportPatch(patch: patch)
            
            Socket.shared.send(message: reportPatch.stringify() ?? "parsing error", completed: completed)
            
            previousFullReport = fullReport
        } catch {
            Logger.shared.log("Error - failed to create json patch")
            completed?()
        }
    }
}
