//
//  Stepper.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class Stepper: Control {
    init(stepper: UIStepper)  {
        super.init(control: stepper)
        
        ancestorType = .uiStepper
    }
}
