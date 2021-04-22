//
//  StandardManualEnterViewModel.swift
//  EvincedSDKiOS
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
    
    var ipText: String? {
        didSet { checkConnectionEnabled() }
    }
    
    @objc dynamic var isConnectEnabled: Bool = false
    
    private let userDefaults: UserDefaults
    private var socketUrl: URL?
    
    init(with userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        super.init()
        ipText = UserDefaults.standard.url(forKey: "previous-evinced-desktop-url")?.absoluteString
        checkConnectionEnabled()
    }
    
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
    
    private func checkConnectionEnabled()  {
        socketUrl = validSocketUrl(ipText ?? "")
        isConnectEnabled = socketUrl != nil
    }
}
