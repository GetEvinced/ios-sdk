//
//  StandardManualEnterViewModel.swift
//  Evinced
//
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import Foundation

class StandardManualEnterViewModel: NSObject, ManualEnterViewModel {
    let isFullScreen: Bool = false
    weak var routingDelegate: RoutingDelegate?
    
    let titleText: String  = "Copy IP address on desktop and paste it below"
    let backButtonText: String = "Back"
    let connectButtonText: String = "Connect"
    
    private var socketUrl: URL?
    
    var ipText: String? {
        didSet {
            socketUrl = validSocketUrl(ipText ?? "")
            isConnectEnabled = socketUrl != nil
        }
    }
    
    @objc dynamic var isConnectEnabled: Bool = false
    
    func backPressed() {
        self.routingDelegate?.manualEnteringCancel()
    }
    
    func connectPressed() {
        guard let socketUrl = socketUrl else {
            isConnectEnabled = false
            return
        }
        
        routingDelegate?.urlDidEntered(socketUrl)
    }
}
