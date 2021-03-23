//
//  Socket.swift
//  EvincedSDKiOS
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation
import Starscream

private class EnvironmentObserver: SocketDelegate {
    
    weak var socket: Socket?
    
    init(socket: Socket,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.socket = socket
        
        notificationCenter.addObserver(self,
                                       selector: #selector(onAcessibilityEvent),
                                       name: UIAccessibility.switchControlStatusDidChangeNotification,
                                       object: nil)
    }
    
    func socket(event: WebSocketEvent) {
        switch event {
        case .connected:
            onConnect()
        default:
            break
        }
    }
    
    func onConnect() {
        DispatchQueue.main.async {
            let sdkBundle = Bundle(for: EnvironmentObserver.self)
            let sdkVersion = sdkBundle.infoDictionary?["CFBundleShortVersionString"] as? String
            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
            let appDisplayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
            let appBundle = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
            let message = SDKInfo(isEnabled: UIAccessibility.isSwitchControlRunning,
                                  sdkVersion: sdkVersion,
                                  appName: appName,
                                  appDisplayName: appDisplayName,
                                  appBundle: appBundle)
            guard let socket = self.socket, let messageString = message.stringify() else { return }
            socket.send(message: messageString)
        }
    }
    
    @objc func onAcessibilityEvent() {
        DispatchQueue.main.async {
            let message = AccessibilityEvent(isEnabled: UIAccessibility.isSwitchControlRunning)
            guard let socket = self.socket, let messageString = message.stringify() else { return }
            socket.send(message: messageString)
        }
    }
}

class Socket: WebSocketDelegate {
    static let shared: Socket = {
        let socket = Socket()
        let switchControlObserver = EnvironmentObserver(socket: socket)
        socket.delegates.append(switchControlObserver)
        return socket
    }()
    
    var running = false
    
    var delegates: [SocketDelegate] = []
    
    var socket: WebSocket?
    var isConnected = false
    
    private var pingTimer: Timer?
    private var reconnectTimer: Timer?
    
    init() {
        Logger.log("Init socket")
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {_ in
            if (self.running && !self.isConnected) {
                self.connect()
            }
        }

        pingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            if (self.isConnected) {
                self.socket?.write(ping: Data())
            }
        }
    }
    
    func start() {
        running = true
        self.connect()
    }
    
    func stop() {
        running = false
        self.disconnect()
    }
    
    func send(message: String) {
        socket?.write(string: message, completion: nil)
    }
    
    func send(message: String, completed: (() -> ())?) {
        DispatchQueue.global(qos: .utility).async {
            if let socket = self.socket {
                socket.write(string: message, completion: completed)
            } else {
                completed?()
            }
        }
    }
    
    func connect() {
        Logger.log("Connecting to websocket")
        
        guard let socketUrl = Locker.shared.socketUrl else {
            Logger.shared.log("Cant connect, no desktop server url")
            return
        }

        Logger.shared.log("Connecting to websocket at \(socketUrl.absoluteString)")
        
        resetConnection()
        
        var request = URLRequest(url: socketUrl)
        request.timeoutInterval = 2
        socket = WebSocket(request: request)
        socket?.respondToPingWithPong = true
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        Logger.shared.log("Disconnecting from websocket")
        resetConnection()
    }
    
    private func resetConnection() {
        isConnected = false
        socket?.delegate = nil
        socket?.forceDisconnect()
        socket = nil
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        for delegate in delegates {
            delegate.socket(event: event)
        }
        switch event {
        case .connected(let headers):
            isConnected = true
            Logger.log("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            Logger.log("websocket is disconnected: \(reason) with code: \(code)")
            guard running else { break }
            resetConnection()
        case .text(let string):
            Logger.log("Received text: \(string)")
            handle(message: string)
        case .binary(let data):
            Logger.log("Received data: \(data.count)")
        case .viabilityChanged(_):
            Logger.log("viabilityChanged")
            break
        case .reconnectSuggested(_):
            Logger.log("reconnectSuggested")
            break
        case .cancelled:
            Logger.log("cancelled")
            resetConnection()
        case .error(let error):
            resetConnection()
            Logger.log("Websocket error : \(String(describing: error))")
        default:
            break
        }
    }
    
    func handle(message: String) {
        DispatchQueue.main.async {
            guard let dict = JSONStringEncoder.decode(text: message),
                  let type = dict["type"] as? String else { return }
            
            // Use this, if needed.
            // let payload = dict["payload"] as? [String: Any]
            
            if type == MessageTypes.scan.rawValue {
                Logger.log("Commands: scan")
                EvincedEngine.scan()
            }
        }
    }
}

enum MessageTypes: String {
    case scan = "scan"
}

protocol SocketDelegate: class {
    func socket(event: WebSocketEvent)
}
