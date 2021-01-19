//
//  Codables.swift
//  Evinced
//
//  Created by Roy Zarchi on 29/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
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
    case uiTextField = "UITextField"
    case uiSearchTextField = "UISearchTextField"
}

protocol BaseCodeable: Codable {}

class Codables {
    class View: BaseCodeable {
        var instanceId: String
        var id: String
        
        var isViewControllerRoot: Bool
        var viewControllerName: String?
        
        var ancestorType: AncestorType = .uiView
        var classType: String
        
        var backgroundColor: String?
        var borderColor: String?
        var borderWidth: CGFloat
        
        var isAccessibilityElement: Bool
        var accessibilityLabel: String?
        var accessibilityIdentifier: String?
        var accessibilityTraits: [String]?
        var accessibilityIgnoresInvertColors: Bool
        var accessibilityFrame: NamedCGRect
        var accessibilityHint: String?
        var accessibilityElementsHidden: Bool
        var accessibilityViewIsModal: Bool

        var clipsToBounds: Bool
        var isHidden: Bool
        var isOpaque: Bool
        var isFocused: Bool
        var isUserInteractionEnabled: Bool
        var frame: NamedCGRect
        var bounds: NamedCGRect
        var opacity: CGFloat
        var gestureRecognizers: [Codables.GestureRecognizer] = []
        var children: [View] = []
        
        init(view: UIView, rootView: UIView) {
            instanceId = UUID().uuidString
            id = view.evincedId()
            isViewControllerRoot = view.findViewController()?.view == view
            viewControllerName = view.findViewController()?.evincedName
            classType = String(describing: type(of: view))
            
            let convertedFrame = view.convert(view.frame, to: rootView)
            frame = NamedCGRect(x: convertedFrame.origin.x,
                                y: convertedFrame.origin.y,
                                width: convertedFrame.width,
                                height: convertedFrame.height)
            
            bounds = NamedCGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
            
            backgroundColor = view.backgroundColor?.hexString
            borderColor = view.layer.borderColor?.hexString
            borderWidth = view.layer.borderWidth
            
            accessibilityLabel = view.accessibilityLabel
            accessibilityIdentifier = view.accessibilityIdentifier
            accessibilityTraits = allTraits
                .filter({view.accessibilityTraits.contains($0.value)})
                .map({$0.key})
            
            gestureRecognizers = view.gestureRecognizers?.map ({
                GestureRecognizer(
                    name: $0.name,
                    cancelsTouchesInView: $0.cancelsTouchesInView,
                    isEnabled: $0.isEnabled,
                    locationInView: $0.location(in: view))
            }) ?? []
            
            opacity = view.alpha
            clipsToBounds = view.clipsToBounds
            isAccessibilityElement = view.isAccessibilityElement
            accessibilityIgnoresInvertColors = view.accessibilityIgnoresInvertColors
            accessibilityFrame = NamedCGRect(x: view.accessibilityFrame.origin.x, y: view.accessibilityFrame.origin.y, width: view.accessibilityFrame.width, height: view.accessibilityFrame.height)
            accessibilityHint = view.accessibilityHint
            accessibilityElementsHidden = view.accessibilityElementsHidden
            
            isUserInteractionEnabled = view.isUserInteractionEnabled
            isHidden = view.isHidden
            isOpaque = view.isOpaque
            isFocused = view.isFocused
            accessibilityViewIsModal = view.accessibilityViewIsModal
        }
    }
    
    struct NamedCGRect: BaseCodeable {
        let x: CGFloat
        let y: CGFloat
        let width: CGFloat
        let height: CGFloat
    }
    
    struct GestureRecognizer: BaseCodeable {
        let name: String?
        let cancelsTouchesInView: Bool?
        let isEnabled: Bool?
        let locationInView: CGPoint?
    }

    class Control: Codables.View {
        var states: [State]
        
        enum CodingKeys: String, CodingKey {
            case states
        }
        
        enum State: String, Encodable {
            case application
            case disabled
            case focused
            case highlighted
            case normal
            case reserved
            case selected
        }
        
        init(control: UIControl, rootView: UIView)  {
            states = control.state.sdkStates
            
            super.init(view: control, rootView: rootView)
            
            ancestorType = .uiControl
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(states, forKey: .states)
            
            try super.encode(to: encoder)
        }
    }
    
    class Button: Control {
        var color: String
        var text: String?
        var iconName: String?
        
        enum CodingKeys: String, CodingKey {
            case text
            case color
            case iconName
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(color, forKey: .color)
            try container.encode(iconName, forKey: .iconName)
            
            try super.encode(to: encoder)
        }
        
        init(button: UIButton, rootView: UIView)  {
            color = button.currentTitleColor.hexString
            text = button.titleLabel?.text
            
            iconName = button.image(for: button.state)?.accessibilityIdentifier
            
            super.init(control: button, rootView: rootView)
            
            ancestorType = .uiButton
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class Slider: Codables.Control {
        init(slider: UISlider, rootView: UIView)  {
            super.init(control: slider, rootView: rootView)
            
            ancestorType = .uiSlider
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class Stepper: Codables.Control {
        init(stepper: UIStepper, rootView: UIView)  {
            super.init(control: stepper, rootView: rootView)
            
            ancestorType = .uiStepper
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class SearchTextField: Codables.TextField {
        init(searchTextField: UITextField, rootView: UIView)  {
            super.init(textField: searchTextField, rootView: rootView)
            
            ancestorType = .uiSearchTextField
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class TextField: Codables.Control {
        init(textField: UITextField, rootView: UIView)  {
            super.init(control: textField, rootView: rootView)
            
            ancestorType = .uiTextField
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class Label: Codables.View {
        var text: String?
        var color: String
        
        var fontSize: CGFloat
        var fontWeight: String // System will return this proprety capitalized
        
        
        enum CodingKeys: String, CodingKey {
            case text
            case color
            case fontSize
            case fontWeight
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(color, forKey: .color)
            
            try container.encode(fontSize, forKey: .fontSize)
            try container.encode(fontWeight, forKey: .fontWeight)
            
            try super.encode(to: encoder)
        }
        
        init(label: UILabel, rootView: UIView)  {
            color = label.textColor.hexString
            text = label.text
            
            let font = label.font! // We could use `!` here
            
            fontSize = font.pointSize
            fontWeight = font.fontDescriptor.object(forKey: .face) as? String ?? ""
            
            super.init(view: label, rootView: rootView)
            
            ancestorType = .uiLabel
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class SearchBar: Codables.View {
        init(searchBar: UISearchBar, rootView: UIView)  {
            super.init(view: searchBar, rootView: rootView)
            
            ancestorType = .uiSearchBar
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class ImageView: Codables.View {
        var resizingMode: Int?
        var hasImage: Bool
        
        enum CodingKeys: String, CodingKey {
            case resizingMode
            case hasImage
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(hasImage, forKey: .hasImage)
            try container.encode(resizingMode, forKey: .resizingMode)
            
            try super.encode(to: encoder)
        }
        
        init(imageView: UIImageView, rootView: UIView)  {
            resizingMode = imageView.image?.resizingMode.rawValue
            hasImage = imageView.image?.resizingMode != nil
            
            super.init(view: imageView, rootView: rootView)
            
            ancestorType = .uiImageView
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }

    struct FullReport: BaseCodeable {
        var type: MessageType = .fullReport
        let tree: Codables.View?
        let snapshot: String?
        let appName: String?
    }
    
    struct ReportPatch: BaseCodeable {
        var type: MessageType = .reportPatch
        let patch: JSONPatch
    }
    
    enum MessageType: String, Codable {
        case fullReport = "full_report"
        case reportPatch = "report_patch"
    }
    
    struct PlayVoiceOver: BaseCodeable {
        let viewId: String
    }
    
    struct ShowMarker: BaseCodeable {
        let viewId: String
    }
    
    struct HideMarker: BaseCodeable {
        let viewId: String
    }
}

extension Codables {
    // string to object func
    class func from<T: Codable>(type: T.Type, string: String) -> T? {
        do {
            if let json = string.data(using: .utf8) {
                let decoder = JSONDecoder()
                let object = try decoder.decode(type.self, from: json)
                
                return object
            }
        } catch {}
        
        return nil
    }
}

extension BaseCodeable {
    // object to string func
    func stringify() -> String? {
        let encoder = JSONEncoder()

        var data: Data?
        
        do {
           data = try encoder.encode(self)
        } catch {}

        let dataAsString = String(data: data!, encoding: .utf8)
    
        return dataAsString
    }
    
    func data() -> Data? {
        let encoder = JSONEncoder()

        var data: Data?
        
        do {
           data = try encoder.encode(self)
        } catch {}
        
        return data
    }
}

private extension UIControl.State {
    var sdkStates: [Codables.Control.State] {
        var sdkStates: [Codables.Control.State] = []
        
        if contains(.application) { sdkStates.append(.application) }
        if contains(.disabled)    { sdkStates.append(.disabled) }
        if contains(.focused)     { sdkStates.append(.focused) }
        if contains(.highlighted) { sdkStates.append(.highlighted) }
        if contains(.normal)      { sdkStates.append(.application) }
        if contains(.reserved)    { sdkStates.append(.reserved) }
        if contains(.selected)    { sdkStates.append(.selected) }
        
        return sdkStates
    }
}
