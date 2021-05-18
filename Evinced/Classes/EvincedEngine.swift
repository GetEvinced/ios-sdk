//
//  EvincedEngine.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import UIKit

@objc public final class EvincedEngine: NSObject {

    static var isRunning: Bool { Socket.shared.running }
    
    @objc public class func start() {
        Socket.shared.start()
    }
    
    @objc public class func stop() {
        Socket.shared.stop()
    }
    
    @objc public class func scan() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let tree = EvincedTree(root: window).tree
        let snapshot = window.imageAsString(jpeg: true)
        
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        
        let fullReport = FullReport(tree: tree,
                                    snapshot: snapshot,
                                    appName: appName)
        
        Manager.shared.sendFullReport(fullReport)
    }
    
    @objc public class func shake(enabled: Bool) {
        Manager.shared.enableShake = enabled
    }
    
    @objc public class func log(enabled: Bool) {
        Logger.isEnabled = enabled
    }
}
