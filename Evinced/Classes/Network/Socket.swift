//
//  Socket.swift
//  Evinced
//
//  Created by Roy Zarchi on 23/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

class Socket: WebSocketDelegate {
    static let shared = Socket()
    
    var running = false
    
    var delegates: [SocketDelegate] = []
    
    var socket: WebSocket?
    var isConnected = false
    
    private var pingTimer: Timer?
    private var reconnectTimer: Timer?
    
    private var isSendingData = false
    
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

        if let ip = Locker.shared.ip {
            Logger.shared.log("Connecting to websocket at \(ip)")
            
            resetConnection()
            
            var request = URLRequest(url: URL(string: "ws://\(ip):8000")!)
            request.timeoutInterval = 2
            socket = WebSocket(request: request)
            socket?.respondToPingWithPong = true
            socket?.delegate = self
            socket?.connect()
        } else {
            Logger.shared.log("Cant connect, no desktop server ip")
        }
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
            resetConnection()
            Logger.log("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            handle(message: string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
//            print("ping")
            break
        case .pong(_):
//            print("pong")
            break
        case .viabilityChanged(_):
            print("viabilityChanged")
            break
        case .reconnectSuggested(_):
            print("reconnectSuggested")
            break
        case .cancelled:
            print("cancelled")
            resetConnection()
        case .error(let error):
            resetConnection()
            Logger.log("Websocket error : \(String(describing: error))")
        }
    }
    
    func handle(message: String) {
        DispatchQueue.main.async {
            if let dict = JSONStringEncoder.decode(text: message) {
                if dict["type"] != nil, dict["payload"] != nil {
                    
                    let type = dict["type"] as! String
                    // Use this, if needed.
//                    let payload = JSONStringEncoder.encode(dict["payload"] as! [String: Any])!
                    
                    if type == MessageTypes.clearData.rawValue {
                        Logger.log("Command: clear")
                        Manager.shared.clear()
                    }
                    
                    
                    if type == MessageTypes.scan.rawValue {
                        Logger.log("Commands: clear, scan")
                        Manager.shared.clear()
                        EvincedEngine.scan()
                    }
                    
                    if type == MessageTypes.smartScan.rawValue {
                        Logger.log("Commands: smart scan")
//                        Manager.shared.clear()
                        EvincedEngine.smartScan()
                    }
                }
            }
        }
    }
}

enum MessageTypes: String {
    case showMarker = "show_marker"
    case hideMarker = "hide_marker"
    case showAllMarkers = "show_all_markers"
    case hideAllMarkers = "hide_all_markers"
    case playVoiceOver = "play_voice_over"
    case scan = "scan"
    case smartScan = "scan_smart"
    case clearData = "clear_data"
}

protocol SocketDelegate {
    func socket(event: WebSocketEvent)
}
