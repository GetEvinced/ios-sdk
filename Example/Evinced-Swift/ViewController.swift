//
//  ViewController.swift
//  LiveSnapshot
//
//  Created by Indragie Karunaratne on 3/30/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import UIKit
import SceneKit
import Evinced

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(someAction(sender:)))
        basicView.addGestureRecognizer(tapGesture)
        
        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(someAction(sender:)))
        imageView.addGestureRecognizer(tapImageGesture)
    }
    
    @objc func someAction(sender:UITapGestureRecognizer){
       // do other task
        print("tappp")
    }
    
    @IBOutlet weak var basicView: UIView!
    //    override func loadView() {
//        let view = UIView()
//        view.backgroundColor = UIColor.cyan
//        view.frame = UIScreen.main.bounds
//        view.accessibilityLabel = "this is text for voice over!!!"
//
//        let frames = view.bounds.divided(atDistance: view.bounds.width / 2, from: .minXEdge)
//        let view1 = UIView()
//        view1.backgroundColor = .yellow
//        view1.frame = frames.slice
//
//        let view2 = UIView()
//        view2.backgroundColor = .purple
//        view2.frame = frames.remainder
//
//        view.addSubview(view1)
//        view.addSubview(view2)
//
//        let frames1 = view1.bounds.divided(atDistance: view1.bounds.height / 2, from: .minYEdge)
//        let view3 = UIView()
//        view3.backgroundColor = .blue
//        view3.frame = frames1.slice
//
//        let overlay = UIView()
//        overlay.backgroundColor = .brown
//        overlay.frame = view3.bounds.insetBy(dx: 20, dy: 20)
//        view3.addSubview(overlay)
//
//        let view4 = UIView()
//        view4.backgroundColor = .orange
//        view4.frame = frames1.remainder
//
//        view1.addSubview(view3)
//        view1.addSubview(view4)
//
//        let frames2 = view2.bounds.divided(atDistance: view2.bounds.height / 2, from: .minYEdge)
//        let view5 = UIView()
//        view5.backgroundColor = .red
//        view5.frame = frames2.slice
//
//        let view6 = UIView()
//        view6.backgroundColor = .green
//        view6.frame = frames2.remainder
//
//        view2.addSubview(view5)
//        view2.addSubview(view6)
//
//        let btn = UIButton()
//        btn.backgroundColor = .black
//        btn.setTitle("This is BUTTON!!!", for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        let views = ["view": overlay, "newView": btn]
//        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=0)-[newView(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
//        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=0)-[newView(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
//        overlay.addConstraints(horizontalConstraints)
//        overlay.addConstraints(verticalConstraints)
//
//        overlay.addSubview(btn)
//
//        if (btn.accessibilityValue == nil) {
//            btn.layer.shadowColor = UIColor.red.cgColor
//            btn.layer.shadowOpacity = 1
//            btn.layer.shadowOffset = .zero
//            btn.layer.shadowRadius = 10
//        }
//
//        self.view = view
//    }
    
    @IBAction func snapshot(sender: UIBarButtonItem) {
        EvincedEngine.present()
    }
    @IBAction func analyze(_ sender: UIBarButtonItem) {
        EvincedEngine.presentLiveForView(UIApplication.shared.keyWindow?.rootViewController?.view)
    }
}

