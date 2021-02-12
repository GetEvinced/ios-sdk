//
//  StandardPageViewProvider.swift
//  Evinced
//
//  Created by Alexandr Lambov on 25.01.2021.
//  Copyright © 2021 Evinced, Inc. All rights reserved.
//

import Foundation

struct StandardPageViewProvider: PageViewProvider {
    func viewController(for pageViewModel: PageViewModel) -> UIViewController {
        if let ipEnterModel = pageViewModel as? IpEnterViewModel {
            return  IpEnterViewController(viewModel: ipEnterModel)
        }
        
        if let qrReadModel = pageViewModel as? QrReadViewModel {
            return  ScannerViewController(viewModel: qrReadModel)
        }
        
        if let manualEnterModel = pageViewModel as? ManualEnterViewModel {
            return ManualEnterViewController(viewModel: manualEnterModel)
        }
        
        if let connectionStatusModel = pageViewModel as? ConnectionStatusViewModel {
            return ConnectionStatusViewController(viewModel: connectionStatusModel)
        }
        
        fatalError("View Model not registered")
    }
}

