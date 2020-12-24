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
        if !MenuViewController.displayed {
            let vc = MenuViewController(nibName: "MenuViewController", bundle: .init(for: MenuViewController.self))
            
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            let topVC = topViewController(rootViewController: rootVC)
            
            topVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    class func show() {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let topVC = topViewController(rootViewController: rootVC)
        
        if let vc = topVC {
            let alert = UIAlertController.init(title: "Evinced", message: "Analyze the app for accessibility issues", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Start", style: .default , handler:{ (UIAlertAction)in
                EvincedEngine.start()
            }))

            alert.addAction(UIAlertAction(title: "Stop", style: .default , handler:{ (UIAlertAction)in
                EvincedEngine.stop()
            }))
            
            alert.addAction(UIAlertAction(title: "Show", style: .default , handler:{ (UIAlertAction)in
//                Manager.shared.showAll()
            }))
            
            alert.addAction(UIAlertAction(title: "Hide", style: .default , handler:{ (UIAlertAction)in
//                Manager.shared.hideAll()
            }))
            
            alert.addAction(UIAlertAction(title: "Scan", style: .default , handler:{ (UIAlertAction)in
//                EvincedEngine.scanApp()
            }))
            
            alert.addAction(UIAlertAction(title: "Send", style: .default , handler:{ (UIAlertAction)in
//                let problems = Manager.shared.problems.values.map({ $0.codable() })
//                let screensFlat = Manager.shared.screensFlat.values.map({ $0.codable() })
//                let tree = Manager.shared.screen?.codable()
//                
//                let report = Codables.FullReport(screen: tree, screensFlat: screensFlat, problems: problems)
//                
//                Socket.shared.send(message: report.stringify() ?? "parsing error")
            }))

            alert.addAction(UIAlertAction(title: "3D Overview", style: .default , handler:{ (UIAlertAction)in
                EvincedEngine.present()
            }))
            
            alert.addTextField { textField in
                print(textField.text ?? "")
                
            }

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in

            }))
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
