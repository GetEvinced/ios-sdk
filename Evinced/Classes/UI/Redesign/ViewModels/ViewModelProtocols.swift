//
//  ViewModelProtocols.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

@objc protocol RoutingDelegate: class {
    func qrReadStart()
    func qrReadCancel()
    func qrDidRead(ip: String)
    func manualIpEnter()
    func manualEnteringCancel()
    func ipDidEntered(ip: String)
    func disconnect()
}

@objc protocol FrameViewModel {
    @objc dynamic var page: PageViewModel { get }
    @objc dynamic var dismiss: Bool { get }
    
    func closePressed()
}

@objc protocol PageViewModel {
    var isFullScreen: Bool { get }
    var routingDelegate: RoutingDelegate? { get set }
}


protocol IpEnterViewModel: PageViewModel {
    var titleText: String { get }
    var scanButtonText: String { get }
    var cantScanText: String { get }
    var enterIpButtonText: String { get }
    
    func qrReadPressed()
    func manualEnterPressed()
}

protocol QrReadViewModel: PageViewModel {
    var backButtonText: String { get }
    var titleText: String { get }
    var descriptionText: String { get }
    
    func backPressed()
    func authorizationIssue()
    func qrDidRead(_ qr: String)
}

@objc protocol ManualEnterViewModel: PageViewModel {
    var titleText: String { get }
    var ipText: String? { get set }
    var backButtonText: String { get }
    var connectButtonText: String { get }
    
    @objc dynamic var isConnectEnabled: Bool { get }
    
    func backPressed()
    func connectPressed()
}

@objc protocol ConnectionStatusViewModel: PageViewModel {
    @objc dynamic var connectionText: String { get }
    var disconnectButtonText: String { get }
    var enableSwitchText: String { get }
    var enableSwitchButtonText: String { get }
    
    @objc dynamic var isSwitchViewHidden: Bool { get }
    
    func disconnectPressed()
    func switchPressed()
    func shouldDisappear()
}


protocol PageViewProvider {
    func viewController(for pageViewModel: PageViewModel) -> UIViewController
}
