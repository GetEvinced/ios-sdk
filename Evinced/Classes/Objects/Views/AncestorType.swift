//
//  AncestorType.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

enum AncestorType: String, Codable {
    case uiView = "UIView"
    case uiLabel = "UILabel"
    case uiImageView = "UIImageView"
    case uiControl = "UIControl"
    case uiButton = "UIButton"
    case uiSlider = "UISlider"
    case uiStepper = "UIStepper"
    case uiSearchBar = "UISearchBar"
    case uiToolbar = "UIToolbar"
    case uiTabBar = "UITabBar"
    case uiNavigationBar = "UINavigationBar"
    case uiTextField = "UITextField"
    case uiSearchTextField = "UISearchTextField"
}
