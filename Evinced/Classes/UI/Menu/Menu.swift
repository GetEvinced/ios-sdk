//
//  Menu.swift
//  Evinced
//
//  Created by Roy Zarchi on 17/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation
import AVFoundation

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if (motion == .motionShake){
            if Manager.shared.enableShake {
                Menu.showController()
            }
        }
    }
}

var timer: Timer?

class Menu: NSObject {
    
    class func showController() {
        let viewModel = StandardFrameViewModel()
        let frameViewController = FrameViewController(viewModel: viewModel,
                                                      routingDelegate: viewModel,
                                                      pageViewProvider: StandardPageViewProvider())
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let topVC = topViewController(rootViewController: rootVC)

        topVC?.present(frameViewController, animated: true, completion: nil)
//        if !MenuViewController.displayed {
//            let vc = MenuViewController(nibName: "MenuViewController", bundle: .init(for: MenuViewController.self))
//
//            let rootVC = UIApplication.shared.keyWindow?.rootViewController
//            let topVC = topViewController(rootViewController: rootVC)
//
//            topVC?.present(vc, animated: true, completion: nil)
//        }
    }
}
