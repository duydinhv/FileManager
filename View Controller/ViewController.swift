//
//  ViewController.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/13/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "http://google.com"){
            UIApplication.shared.open(url)
        
        }
    }
   }



