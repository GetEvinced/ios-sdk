////
////  Screen.swift
////  Evinced
////
////  Created by Roy Zarchi on 29/07/2020.
////  Copyright © 2020 Indragie Karunaratne. All rights reserved.
////
//
//import Foundation
//
//class Screen {
//    var id: String
//    var name: String
//    var vc: UIViewController
//    var image: String?
//    var children: [String: Screen]
//    var isReady = false
//    var onReady: ((Screen) -> Void)?
//    
//    init(id: String,
//         vc: UIViewController,
//         name: String,
//         image: String?,
//         children: [String: Screen],
//         onReady: ((Screen) -> Void)? = nil) {
//        self.id = id
//        self.vc = vc
//        self.name = name
//        self.image = image
//        self.children = children
//        self.onReady = onReady
//        
////        self.image = vc.view.imageUnclipped?.png?.base64EncodedString()
//        
//        vc.view.disableClippingAndRun {
//            var image: CGImage? = nil
//
//            let renderer = UIGraphicsImageRenderer(bounds: vc.view.getMaxBounds())
//            image =  renderer.image { rendererContext in
//                vc.view.layer.masksToBounds = false
//                vc.view.layer.render(in: rendererContext.cgContext)
//            }.cgImage
//
//            self.image = image?.png?.base64EncodedString()
//            self.isReady = true
//            self.onReady?(self)
//        }
//        
////        vc.view.imageAsStringAsync(unclipped: true, completion: { image in
////            self.image = image
////
////            self.isReady = true
////            self.onReady?(self)
////        })
//    }
//    
//    func merge(screen: Screen) {
//        if id == screen.id {
//            vc = screen.vc
//            name = screen.name
//            image = screen.image
//            
//            for child in screen.children {
//                if let existingChild = children[child.key] {
//                    existingChild.merge(screen: child.value)
//                } else {
//                    children[child.key] = child.value
//                }
//            }
//        } else {
//            print("ROY: screen id error, id: \(id), screen.id: \(screen.id)")
//        }
//    }
//    
//    func codable() -> Codables.Screen {
//        func convertScreen(screen: Screen) -> Codables.Screen {
//            let children = screen.children.values.map({ child in
//                return convertScreen(screen: child)
//            })
//            
//            return Codables.Screen(
//                id: screen.id,
//                name: screen.name,
//                image: screen.image,
//                children: children)
//        }
//        
//        return convertScreen(screen: self)
//    }
//}
