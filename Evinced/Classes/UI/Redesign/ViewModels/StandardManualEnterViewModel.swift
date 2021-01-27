//
//  StandardManualEnterViewModel.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

class StandardManualEnterViewModel: NSObject, ManualEnterViewModel {
    let isFullScreen: Bool = false
    weak var routingDelegate: RoutingDelegate?
    
    let titleText: String  = "Copy IP address on desktop and paste it below"
    let backButtonText: String = "Back"
    let connectButtonText: String = "Connect"
    
    var ipText: String? {
        didSet { isConnectEnabled = validateIpAddress(ipToValidate: ipText ?? "") }
    }
    
    @objc dynamic var isConnectEnabled: Bool = false
    
    func backPressed() {
        self.routingDelegate?.manualEnteringCancel()
    }
    
    func connectPressed() {
        guard let ipText = ipText, validateIpAddress(ipToValidate: ipText) else {
            isConnectEnabled = false
            return
        }
        
        routingDelegate?.ipDidEntered(ip: ipText)
    }
}
