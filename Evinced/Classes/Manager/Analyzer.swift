////
////  Analyzer.swift
////  Evinced
////
////  Created by Roy Zarchi on 17/07/2020.
////  Copyright © 2020 Indragie Karunaratne. All rights reserved.
////
//
//import Foundation
//
//class Analyzer: NSObject {
//    
//    class Scan {
//        private var problems: [String: BaseProblem] = [:]
//        private var problemsState: [String: Bool] = [:]
//        
//        private var screens: [String: Screen] = [:]
//        private var screensState: [String: Bool] = [:]
//        
//        private var tree: Codables.View?
//        
//        private let onReady: ([String: BaseProblem], [String: Screen]) -> Void
//        
//        private var notifyIfReady = false
//        
//        // API
//        
//        init(onReady: @escaping ([String: BaseProblem], [String: Screen]) -> Void) {
//            self.onReady = onReady
//        }
//        
//        func start(root: Element) {
//            Logger.log("Starting scan")
//            analyze(root: root)
//            Logger.log("Scan done, problems count: \(problems.count)")
//            notifyWhenReady()
//        }
//        
//        // Private
//        
//        private func add(problem: BaseProblem) {
//            problems[problem.id] = problem
//            problemsState[problem.id] = problem.isReady
//            problem.onReady = { problem in
//                self.problemsState[problem.id] = true
//                self.notifyIfNeeded()
//            }
//        }
//        
//        private func add(screen: Screen) {
//            screens[screen.id] = screen
//            screensState[screen.id] = screen.isReady
//            screen.onReady = { screen in
//                self.screensState[screen.id] = true
//                self.notifyIfNeeded()
//            }
//        }
//        
//        private func notifyWhenReady() {
//            self.notifyIfReady = true
//            notifyIfNeeded()
//        }
//        
//        // Private funcs
//        
//        private func notifyIfNeeded() {
//            if notifyIfReady {
//                var allJobsDone = true
//                
//                for state in problemsState.values {
//                    if state == false {
//                        allJobsDone = false
//                    }
//                }
//                
//                for state in screensState.values {
//                    if state == false {
//                        allJobsDone = false
//                    }
//                }
//                
//                if allJobsDone {
//                    self.onReady(problems, screens)
//                }
//                
//                print(problems.values.filter({ $0.isReady == false }).count)
//                
//                if problems.values.filter({ $0.isReady == false }).count < 3 {
//                    Logger.log(problems.values.filter({ $0.isReady == false }).map({ $0.id }).joined())
//                }
////                print("Problems: \(problemsState.values)")
////                print("Screens: \(screensState.values)")
//            }
//        }
//        
//        
//        private func analyze(root: Element) {
//            if root.view != nil && root.view?.accessibilityLabel?.contains("EVINCED_SKIP") != true {
//                
//                // If the view belongs to a view controller, create a screen object
//                if let vc = root.view?.findViewController() {
//                    if vc.view == root.view {
//                        let screen = Screen(
//                            id: vc.evincedId(),
//                            vc: vc,
//                            name: vc.evincedName,
//                            image: nil,//vc.view.imageUnclipped?.png?.base64EncodedString(),
//                            children: [:]
//                        )
//                        
//                        add(screen: screen)
//                    }
//                }
//                
//                // Here we try to find issues
//                
//                // Add more validations here
//                let problemsTested = [
////                    Problems.ColorContrastInsufficient(element: root),
//                    Problems.LabelMissing(element: root),
//                    Problems.LabelDerived(element: root),
//                    Problems.ShouldHaveButtonTrait(element: root)
//                ]
//                
//                for problem in problemsTested {
//                    if let problem = problem {
//                        add(problem: problem)
//                    }
//                }
//            }
//                
//            if root.view?.accessibilityLabel?.contains("EVINCED_SKIP_RECURSIVE") != true {
//                for subview in root.children {
//                    analyze(root: subview)
//                }
//            }
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    class func reset(root: Element) {
//        if let view = root.view {
//            if view.accessibilityIdentifier == "EVINCED_VIEW_OVERLAY" {
//                view.removeFromSuperview()
//            }
//        }
//        
//        for subview in root.children {
//            reset(root: subview)
//        }
//    }
//    
//    class func analyze(root: Element) {
//        if root.view != nil {
//            
//            if let vc = root.view?.findViewController() {
//                if vc.view == root.view {
//                    let screen = Screen(
//                        id: vc.evincedId(),
//                        vc: vc,
//                        name: vc.evincedName,
//                        image: nil, //vc.view.imageUnclipped?.png?.base64EncodedString(),
//                        children: [:])
//                    
//                    Manager.shared.screensFlat[screen.id] = screen
//                }
//            }
//            
//            // Add more validations here
//            let problems = [
//                Problems.LabelMissing(element: root),
//                Problems.LabelDerived(element: root),
//                Problems.ShouldHaveButtonTrait(element: root)
//            ]
//            
//            for problem in problems {
//                if let problem = problem {
//                    if Manager.shared.problems[problem.id] == nil ||
//                        Manager.shared.problems[problem.id]?.element.view == nil {
//                        Manager.shared.problems[problem.id] = problem
//                    }
//                }
//            }
//        }
//            
//        for subview in root.children {
//            analyze(root: subview)
//        }
//    }
//    
//    class func scanViewControllers() {
//        func registerScreen(vc: UIViewController) -> Screen {
//            var children:[String: Screen] = [:]
//            
//            if vc.children.count <= 0 {
//                if let presentedVC = vc.presentedViewController {
//                    children[presentedVC.evincedId()] = registerScreen(vc: presentedVC)
//                }
//            }
//            
//            for child in vc.children {
//                children[child.evincedId()] = registerScreen(vc: child)
//            }
//            
//    
//            
//            return Screen(
//                id: vc.evincedId(),
//                vc: vc,
//                name: vc.evincedName,
//                image: nil, //vc.view.imageUnclipped?.png?.base64EncodedString(),
//                children: children
//            )
//        }
//        
//        if let root = UIApplication.shared.delegate?.window??.rootViewController {
//            let tree = registerScreen(vc: root)
//            
//            if let baseTree = Manager.shared.screen {
//                baseTree.merge(screen: tree)
//            } else {
//                Manager.shared.screen = tree
//            }
//        }
//    }
//}
