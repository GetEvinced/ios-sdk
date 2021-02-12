//
//  StandardFrameViewModel.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import Foundation

final class StandardFrameViewModel: NSObject, FrameViewModel {
    @objc dynamic var page: PageViewModel {
        didSet { page.routingDelegate = self }
    }
    @objc dynamic var dismiss: Bool = false
    
    override init() {
        page = Socket.shared.isConnected ? StandardConnectionStatusViewModel() : StandardIpEnterViewModel()
        
        super.init()
        
        page.routingDelegate = self
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
    
    func manualIpEnter() {
        page = StandardManualEnterViewModel()
    }
    
    func manualEnteringCancel() {
        page = StandardIpEnterViewModel()
    }
    
    func urlDidEntered(_ url: URL) {
        Locker.shared.socketUrl = url
        page = StandardConnectionStatusViewModel()
    }
    
    func disconnect() {
        Socket.shared.disconnect()
        Locker.shared.socketUrl = nil
        page = StandardIpEnterViewModel()
    }
}
