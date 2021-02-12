//
//  StandardQrReadViewModel.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import Foundation

final class StandardQrReadViewModel: NSObject, QrReadViewModel, ErrorMessageSource {
    let isFullScreen: Bool = true
    weak var routingDelegate: RoutingDelegate?
    weak var errorMessageDelegate: ErrorMessageDelegate?
    
    let backButtonText: String = "Back"
    let titleText: String = "Scan QR Code"
    let descriptionText: String = "Scan the QR code to connect to Evinced desktop application"
    
    func backPressed() {
        routingDelegate?.qrReadCancel()
    }
    
    func authorizationIssue() {
        // Just to be sure we're on the main thread.
        DispatchQueue.main.async { [unowned self] in
            self.errorMessageDelegate?.errorMessage(
                "Your device does not support scanning a code from an item. " +
                "Please use a device with a camera, check 'NSCameraUsageDescription' and check camera permissions."
            ) { [weak self] in
                self?.routingDelegate?.qrReadCancel()
            }
        }
    }
    
    func qrDidReadValid(_ qr: String) -> Bool {
        guard let socketUrl = validSocketUrl(qr) else { return false }
        
        routingDelegate?.urlDidEntered(socketUrl)
        return true
    }
}
