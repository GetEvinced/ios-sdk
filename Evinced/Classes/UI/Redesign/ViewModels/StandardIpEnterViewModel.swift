//
//  StandardIpEnterViewModel.swift
//  Evinced
//
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import Foundation

final class StandardIpEnterViewModel: NSObject, IpEnterViewModel {
    let isFullScreen: Bool = false
    weak var routingDelegate: RoutingDelegate?
    
    let titleText: String = "Scan the QR code to connect to Evinced desktop application"
    let scanButtonText: String = "Scan QR Code"
    let cantScanText: String = "Can’t scan it?"
    let enterIpButtonText: String = "Enter IP address manually"
    
    func qrReadPressed() {
        routingDelegate?.qrReadStart()
    }
    
    func manualEnterPressed() {
        routingDelegate?.manualIpEnter()
    }
}

