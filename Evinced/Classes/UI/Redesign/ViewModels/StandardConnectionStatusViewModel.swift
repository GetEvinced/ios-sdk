//
//  StandardConnectionStatusViewModel.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

final class StandardConnectionStatusViewModel: NSObject, ConnectionStatusViewModel {
    @objc dynamic var connectionText: String
    var disconnectButtonText: String = "Disconnect"
    
    var enableSwitchText: String = "Enable Switch Control to start scanning"
    var enableSwitchButtonText: String = "Enable Switch Control"
    
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
        result += " to \(locker.ip ?? "")"
        return result
    }
    
    @objc private func switchControlStatusChanged(_ notification: Notification) {
        isSwitchViewHidden = UIAccessibility.isSwitchControlRunning
        let message = Codables.AccessibilityStatus(isEnabled: UIAccessibility.isSwitchControlRunning)
        guard let socketManager = socketManager, let messageString = message.stringify() else { return }
        socketManager.send(message: messageString)
    }
}

extension StandardConnectionStatusViewModel: SocketDelegate {
    func socket(event: WebSocketEvent) {
        switch event {
        case .connected:
            connectionText = StandardConnectionStatusViewModel.fullConnectionText(isConnected: true,
                                                                                  locker: locker)
        default:
            break
        }
    }
}