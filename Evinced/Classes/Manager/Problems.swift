////
////  Problems.swift
////  Evinced
////
////  Created by Roy Zarchi on 20/07/2020.
////  Copyright © 2020 Indragie Karunaratne. All rights reserved.
////
//
//import Foundation
//
//class BaseProblem {
//    var element: Element
//    var marker: UIEvincedMarker?
//    var id: String
//    var name: String
//    var vcId: String
//    var image: String?
//    var containerImage: String?
//    var isLive: Bool { get { element.view != nil } }
//    var description: String { get { "Description of problem" } }
//    var problemTypeId: Int { get { -1 } }
//    var coordinates: CGRect?
//    var screenFrame: CGRect?
//    var isReady = false
//    var onReady: ((BaseProblem) -> Void)?
//    
//    init?(element: Element, onReady: (() -> Void)? = nil) {
//        self.element = element
//        guard element.view != nil else { return nil }
//        
//        self.id = element.view!.evincedId()
//        
//        if id == "EVINCED" { return nil }
//        
//        self.vcId = element.view!.findViewController()?.evincedId() ?? "unknown"
//        self.name = (self.element.view != nil) ? String(describing: type(of: self.element.view!)) : "UIView"
//        self.coordinates = element.view!.globalPoint
//        self.screenFrame = self.element.view?.findViewController()?.view.frame
//        
//        guard doesProblemExist(view: element.view!) else { return nil }
//    
////        let marker = UIEvincedMarker()
////        if (Manager.shared.showMarkers) {
////            marker.show()
////        } else {
////            marker.hide()
////        }
////
////        marker.addSelfTo(view: element.view!)
////        self.marker = marker
//        
//        self.containerImage = nil
//        //element.view?.findViewController()?.view.imageUnclipped?.png?.base64EncodedString()
//        self.id += "---type-\(self.problemTypeId)"
//        
////        self.image = element.view?.image?.png?.base64EncodedString()
//        
//        self.element.view?.imageAsStringAsync(completion: { image in
//            self.image = image
//            
//            self.element.view?.findViewController()?.view.imageAsStringAsync(jpeg: true, unclipped: true, completion: {
//                image in
//                self.containerImage = image
//                
//                self.isReady = true
//                self.onReady?(self)
//            })
//        })
//    }
//    
//    // Should override this function on subclasses
//    func doesProblemExist(view: UIView) -> Bool {
//        return false
//    }
//    
//    func update(problem: BaseProblem) {
//        element = problem.element
//        image = problem.image
//        marker = problem.marker
//        name = problem.name
//        vcId = problem.vcId
//    }
//    
//    func codable() -> Codables.Problem {
//        return Codables.Problem(
//            id: self.id,
//            name: self.name,
//            vcId: self.vcId,
//            description: self.description,
//            isLive: self.isLive,
//            problemTypeId: self.problemTypeId,
//            image: self.image,
//            containerImage: self.containerImage,
//            coordinates: self.coordinates,
//            screenFrame: self.screenFrame)
//    }
//}
//
//class Problems {
//    class LabelMissing: BaseProblem {
//        override var description: String { get { "Accessibility label is missing" } }
//        override var problemTypeId: Int { get { 1 } }
//        
//        override func doesProblemExist(view: UIView) -> Bool {
//            
////            Logger.log("\(Validator.enabled(view: view)) \(Validator.accessible(view: view))  \(Validator.labelMissing(view: view))")
//
//            return Validator.enabled(view: view) &&
//                Validator.accessible(view: view) &&
//                Validator.labelMissing(view: view)
//        }
//    }
//    
//    class LabelDerived: BaseProblem {
//        override var description: String { get { "Accessibility label is not explicitly set" } }
//        override var problemTypeId: Int { get { 2 } }
//        
//        override func doesProblemExist(view: UIView) -> Bool {
//            return Validator.enabled(view: view) &&
//                Validator.accessible(view: view) &&
//                Validator.equalType(view: view, isExactlySameTypeAs: "UIButton") &&
//                Validator.Button.AccLabel.isDerivedFromIcon(button: view as! UIButton)
//        }
//    }
//    
//    class ShouldHaveButtonTrait: BaseProblem {
//        override var description: String { get { "View is clickable but button trait is missing" } }
//        override var problemTypeId: Int { get { 3 } }
//        
//        override func doesProblemExist(view: UIView) -> Bool {
//            return Validator.enabled(view: view) &&
//                Validator.accessible(view: view) &&
//                !Validator.hasTrait(view: view, trait: .button) &&
//                Validator.isClickable(view: view)
//        }
//    }
//    
//    class ShouldBeEnabled: BaseProblem {
//        override var description: String { get { "Item should be accessible" } }
//        override var problemTypeId: Int { get { 4 } }
//        
//        override func doesProblemExist(view: UIView) -> Bool {
//            return Validator.enabled(view: view) &&
//                !Validator.accessible(view: view)
//        }
//    }
//    
//    class ColorContrastInsufficient: BaseProblem {
//        override var description: String { get { "Color contrast is insufficient" } }
//        override var problemTypeId: Int { get { 5 } }
//        
//        override func doesProblemExist(view: UIView) -> Bool {
//            if Validator.equalType(view: view, isExactlySameTypeAs: "UILabel") {
//                let label = view as! UILabel
//                
//                let text = label.text
//                let textColor = label.textColor
//                
//                label.text = ""
//            
//                let backgroundColor = UIApplication.shared.keyWindow?.image(bounds: view.frame)?.averageColor
////                let backgroundImage = UIApplication.shared.keyWindow?.image(bounds: view.frame)
//                
//                label.text = text
//                
//                if let bg = backgroundColor, let ratio = textColor?.contrastRatio(with: bg) {
////                    print("Color Ratio: \(ratio)")
//                    return ratio < 4.5
//                }
//            }
//            
//            return false
//        }
//    }
//}
