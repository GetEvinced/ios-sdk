//
//  ViewController.swift
//  LiveSnapshot
//
//  Created by Indragie Karunaratne on 3/30/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import UIKit
import SceneKit
import EvincedSDKiOS

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
}

