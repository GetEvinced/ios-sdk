//
//  InAppViewDebugger.swift
//  InAppViewDebugger
//
//  Created by Indragie Karunaratne on 4/4/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import UIKit

/// Exposes APIs for presenting the view debugger.
@objc public final class EvincedEngine: NSObject {

    static var isRunning: Bool { Socket.shared.running }
    
    @objc public class func start() {
        Socket.shared.start()
    }
    
    @objc public class func stop() {
        Socket.shared.stop()
    }
    
    @objc public class func scan() {
        let window: UIWindow
        
        if #available(iOS 13.0, *) {
            guard let schene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let activeWindow = schene.windows.first else { return }
            window = activeWindow
        } else {
            guard let activeWindow = UIApplication.shared.keyWindow else { return }
            window = activeWindow
        }
        
        let tree = EvincedTree(root: window).tree
        let snapshot = window.imageAsString(jpeg: true)
        
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        
        let fullReport = FullReport(tree: tree,
                                    snapshot: snapshot,
                                    appName: appName)
        
        Manager.shared.sendFullReport(fullReport)
    }
    
    @objc public class func shake(enabled: Bool) {
        Manager.shared.enableShake = enabled
    }
    
    @objc public class func log(enabled: Bool) {
        Logger.enabled = enabled
    }
    
    /// Takes a snapshot of the application's key window and presents the debugger
    /// view controller from the root view controller.
    @objc public class func present() {
        presentForWindow(UIApplication.shared.keyWindow)
    }
    /// Takes a snapshot of the specified window and presents the debugger view controller
    /// from the root view controller.
    ///
    /// - Parameters:
    ///   - window: The view controller whose view should be snapshotted.
    ///   - configuration: Optional configuration for the view debugger.
    ///   - completion: Completion block to be called once the view debugger has
    ///   been presented.
    @objc public class func presentForWindow(_ window: UIWindow?, configuration: Configuration? = nil, completion: (() -> Void)? = nil) {
        guard let window = window else {
            return
        }
        let snapshot = Snapshot(element: ViewElement(view: window))
        presentWithSnapshot(snapshot, rootViewController: window.rootViewController, configuration: configuration, completion: completion)
    }
    
    /// Takes a snapshot of the specified view and presents the debugger view controller
    /// from the nearest ancestor view controller.
    ///
    /// - Parameters:
    ///   - view: The view controller whose view should be snapshotted.
    ///   - configuration: Optional configuration for the view debugger.
    ///   - completion: Completion block to be called once the view debugger has
    ///   been presented.
    @objc public class func presentForView(_ view: UIView?, configuration: Configuration? = nil, completion: (() -> Void)? = nil) {
        guard let view = view else {
            return
        }
        let snapshot = Snapshot(element: ViewElement(view: view))
        presentWithSnapshot(snapshot, rootViewController: getNearestAncestorViewController(responder: view), configuration: configuration, completion: completion)
    }
    
    @objc public class func presentLiveForView(_ view: UIView?, configuration: Configuration? = nil, completion: (() -> Void)? = nil) {
//        guard let view = view else {
//            return
//        }
//        
//        let root = ViewElement(view: view)
        
//        Analyzer.analyze(root: root)
        
//        Markers.markUIButtons(rootElement: root)
//        Markers.markUILabels(rootElement: root)
    }
    
    /// Takes a snapshot of the view of the specified view controller and presents
    /// the debugger view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller whose view should be snapshotted.
    ///   - configuration: Optional configuration for the view debugger.
    ///   - completion: Completion block to be called once the view debugger has
    ///   been presented.
    @objc public class func presentForViewController(_ viewController: UIViewController?, configuration: Configuration? = nil, completion: (() -> Void)? = nil) {
        guard let view = viewController?.view else {
            return
        }
        let snapshot = Snapshot(element: ViewElement(view: view))
        presentWithSnapshot(snapshot, rootViewController: viewController, configuration: configuration, completion: completion)
    }
    
    /// Presents a view debugger for the a snapshot as a modal view controller on
    /// top of the specified root view controller.
    ///
    /// - Parameters:
    ///   - snapshot: The snapshot to render.
    ///   - rootViewController: The root view controller to present the debugger view
    ///   controller from.
    ///   - configuration: Optional configuration for the view debugger.
    ///   - completion: Completion block to be called once the view debugger has
    ///   been presented.
    @objc public class func presentWithSnapshot(_ snapshot: Snapshot, rootViewController: UIViewController?, configuration: Configuration? = nil, completion: (() -> Void)? = nil) {
        guard let rootViewController = rootViewController else {
            return
        }
        let debuggerViewController = ViewDebuggerViewController(snapshot: snapshot, configuration: configuration ?? Configuration())
        let navigationController = UINavigationController(rootViewController: debuggerViewController)
        topViewController(rootViewController: rootViewController)?.present(navigationController, animated: true, completion: completion)
    }
    
    @available(*, unavailable)
    override init() {
        fatalError()
    }
}
