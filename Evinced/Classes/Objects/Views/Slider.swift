//
//  Slider.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class Slider: Control {
    init(slider: UISlider)  {
        super.init(control: slider)
        
        ancestorType = .uiSlider
    }
}
