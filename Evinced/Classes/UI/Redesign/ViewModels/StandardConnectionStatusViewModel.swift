//
//  StandardConnectionStatusViewModel.swift
//  EvincedSDKiOS
//
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import Foundation
import Starscream

final class StandardConnectionStatusViewModel: NSObject, ConnectionStatusViewModel {
    @objc dynamic var connectionText: String
    @objc dynamic var disconnectButtonText: String = "Disconnect"
    
    var enableSwitchText: String = "Enable Switch Control to start scanning"
    var enableSwitchButtonText: String = "Enable Switch Control"
    
    @objc dynamic var connectionImage: UIImage? = UIImage.bundledImage(named: "checkmark")
    
    @objc dynamic var isSwitchViewHidden: Bool = UIAccessibility.isSwitchControlRunning
    
    var isFullScreen: Bool = false
    
    weak var routingDelegate: RoutingDelegate?
    
    private let locker: Locker
    private weak var socketManager: Socket?
    
    init(socketManager: Socket = Socket.shared,
         locker: Locker = Locker.shared,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.locker = locker
        self.socketManager = socketManager
        
        connectionText = StandardConnectionStatusViewModel.fullConnectionText(isConnected: socketManager.isConnected,
                                                                              locker: locker)
        disconnectButtonText = StandardConnectionStatusViewModel.disconnectionText(isConnected: socketManager.isConnected)
        connectionImage = StandardConnectionStatusViewModel.connectionImage(isConnected: socketManager.isConnected)
        
        super.init()
        
        notificationCenter.addObserver(self,
                                       selector: #selector(switchControlStatusChanged(_:)),
                                       name: UIAccessibility.switchControlStatusDidChangeNotification,
                                       object: nil)
        
        socketManager.delegates.append(self)
    }
    
    func disconnectPressed() {
        routingDelegate?.disconnect()
    }
    
    func switchPressed() {
        let sharedApplication = UIApplication.shared
        // We could use undocumented API because the SDK is not intended to get into producation builds
        guard let accessibilitySettingsUrl = URL(string:"App-Prefs:root=ACCESSIBILITY") ?? URL(string: UIApplication.openSettingsURLString),
              sharedApplication.canOpenURL(accessibilitySettingsUrl) else {
            return
        }
        
        sharedApplication.open(accessibilitySettingsUrl)
    }
    
    func shouldDisappear() {
        socketManager?.delegates.removeAll(where: { $0 === self })
    }
    
    static func fullConnectionText(isConnected: Bool, locker: Locker) -> String {
        var result = isConnected ? "Connected" : "Connecting"
        result += " to \(locker.socketUrl?.host  ?? "")"
        return result
    }
    
    static func disconnectionText(isConnected: Bool) -> String {
        return isConnected ? "Disconnect" : "Stop Connection"
    }
    
    static func connectionImage(isConnected: Bool) -> UIImage? {
        return UIImage.bundledImage(named: isConnected ? "checkmark" : "refreshing")
    }
    
    @objc private func switchControlStatusChanged(_ notification: Notification) {
        isSwitchViewHidden = UIAccessibility.isSwitchControlRunning
    }
}

extension StandardConnectionStatusViewModel: SocketDelegate {
    func socket(event: WebSocketEvent) {
        switch event {
        case .connected:
            connectionText = StandardConnectionStatusViewModel.fullConnectionText(isConnected: true,
                                                                                  locker: locker)
            disconnectButtonText = StandardConnectionStatusViewModel.disconnectionText(isConnected: true)
            connectionImage = StandardConnectionStatusViewModel.connectionImage(isConnected: true)
        default:
            break
        }
    }
}
