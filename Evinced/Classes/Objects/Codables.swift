//
//  Codables.swift
//  Evinced
//
//  Created by Roy Zarchi on 29/07/2020.
//  Copyright © 2020 Indragie Karunaratne. All rights reserved.
//

import Foundation

public protocol BaseCodeable: Codable {}

public class Codables {
    class View: BaseCodeable {
        var instanceId: String
        var id: String
        var isViewControllerRoot: Bool
        var viewControllerName: String?
        var classType: String
        var backgroundColor: String?
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
        var snapshot: String?
        
        init(view: UIView) {
            instanceId = UUID().uuidString
            id = view.evincedId()
            isViewControllerRoot = view.findViewController()?.view == view
            viewControllerName = view.findViewController()?.evincedName
            classType = String(describing: type(of: view))
            frame = NamedCGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
            bounds = NamedCGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height)
            backgroundColor = view.backgroundColor?.hexString
            
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
            
            snapshot = (String(describing: type(of: view)) == "UIButton" || String(describing: type(of: view)) == "UILabel" || String(describing: type(of: view)) == "UIImageView" || view.gestureRecognizers?.count ?? 0 > 0) ? view.image?.png?.base64EncodedString() : nil
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

    class Button: Codables.View {
        var color: String
        var text: String?
        var iconName: String?
        var state: String?
        
        enum CodingKeys: String, CodingKey {
            case text
            case color
            case state
            case iconName
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(color, forKey: .color)
            try container.encode(state, forKey: .state)
            try container.encode(iconName, forKey: .iconName)
            
            try super.encode(to: encoder)
        }
        
        init(button: UIButton) {
            color = button.currentTitleColor.hexString
            text = button.titleLabel?.text
            
            switch button.state {
            case .application:
                state = "application"
            case .disabled:
                state = "disabled"
            case .focused:
                state = "focused"
            case .highlighted:
                state = "highlighted"
            case .normal:
                state = "normal"
            case .reserved:
                state = "reserved"
            case .selected:
                state = "selected"
            default:
                state = "unknown"
            }
            
            iconName = button.image(for: button.state)?.accessibilityIdentifier
            
            super.init(view: button)
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }
    
    class Label: Codables.View {
        var color: String
        var text: String?
        
        enum CodingKeys: String, CodingKey {
            case text
            case color
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(color, forKey: .color)
            
            try super.encode(to: encoder)
        }
        
        init(label: UILabel) {
            color = label.textColor.hexString
            text = label.text
            
            super.init(view: label)
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
        
        init(imageView: UIImageView) {
            resizingMode = imageView.image?.resizingMode.rawValue
            hasImage = imageView.image?.resizingMode != nil
            
            super.init(view: imageView)
        }
        
        required init(from decoder: Decoder) throws {
            fatalError("init(from:) has not been implemented")
        }
    }

    struct FullReport: BaseCodeable {
        var type: MessageType { .fullReport }
        let tree: Codables.View?
        let snapshot: String?
        let appName: String?
    }
    
    struct ReportPatch: BaseCodeable {
        var type: MessageType { .reportPatch }
        let patch: JSONPatch
    }
    
    enum MessageType: String {
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
