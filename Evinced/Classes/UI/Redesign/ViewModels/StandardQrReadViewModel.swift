//
//  StandardQrReadViewModel.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

final class StandardQrReadViewModel: NSObject, QrReadViewModel {
    let isFullScreen: Bool = true
    weak var routingDelegate: RoutingDelegate?
    
    let backButtonText: String = "Back"
    let titleText: String = "Scan QR Code"
    let descriptionText: String = "Scan the QR code to connect to Evinced desktop application"
    
    func backPressed() {
        routingDelegate?.qrReadCancel()
    }
    
    func authorizationIssue() {
        
    }
    
    func qrDidRead(_ qr: String) {
        routingDelegate?.qrDidRead(ip: qr)
    }
}
