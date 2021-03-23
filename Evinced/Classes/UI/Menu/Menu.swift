//
//  Menu.swift
//  EvincedSDKiOS
//
//  Copyright © 2020 Evinced, Inc. All rights reserved.
//

import Foundation
import AVFoundation

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        guard Socket.shared.running else { return }
        if (motion == .motionShake){
            if Manager.shared.enableShake {
                Menu.showController()
            }
        }
    }
}

var timer: Timer?

class Menu {
    
    private static weak var currentController: UIViewController?
    
    class func showController() {
        guard currentController == nil else { return }
        
        let viewModel = StandardFrameViewModel()
        let frameViewController = FrameViewController(viewModel: viewModel,
                                                      routingDelegate: viewModel,
                                                      pageViewProvider: StandardPageViewProvider())
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let topVC = topViewController(rootViewController: rootVC)

        topVC?.present(frameViewController, animated: true, completion: nil)
        
        currentController = frameViewController
    }
}
