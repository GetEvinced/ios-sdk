//
//  StandardFrameViewModel.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

final class StandardFrameViewModel: NSObject, FrameViewModel {
    @objc dynamic var page: PageViewModel
    @objc dynamic var dismiss: Bool = false
    
    override init() {
        page = Socket.shared.isConnected ? StandardConnectionStatusViewModel() : StandardIpEnterViewModel()
        
        super.init()
    }
    
    func closePressed() {
        dismiss = true
    }
}

extension StandardFrameViewModel: RoutingDelegate {
    
    func qrReadStart() {
        page = StandardQrReadViewModel()
    }
    
    func qrReadCancel() {
        page = StandardIpEnterViewModel()
    }
    
    func qrDidRead(ip: String) {
        Locker.shared.set(ip: ip)
        page = StandardConnectionStatusViewModel()
    }
    
    func manualIpEnter() {
        page = StandardManualEnterViewModel()
    }
    
    func manualEnteringCancel() {
        page = StandardIpEnterViewModel()
    }
    
    func ipDidEntered(ip: String) {
        Locker.shared.set(ip: ip)
        page = StandardConnectionStatusViewModel()
    }
    
    func disconnect() {
        Socket.shared.disconnect()
        page = StandardIpEnterViewModel()
    }
}
