//
//  ViewController.swift
//  LiveSnapshot
//
//  Created by Indragie Karunaratne on 3/30/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

import UIKit
import EvincedSDKiOS

class ViewController2: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    
    @IBAction func btn(_ sender: UIButton) {
        print(topBtn.evincedId())
//        let img = self.view.imageUnclipped
        print(scrollView.clipsToBounds)
        print(topBtn.evincedId())
    }
}

