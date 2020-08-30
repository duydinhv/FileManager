//
//  SettingController.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/13/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func OpenAS(_ sender: UIButton) {
        if let url = URL(string: "itms-apps://itunes.apple.com"){
        UIApplication.shared.open(url)
        }
    }
    
    @IBAction func sort(_ sender: UIButton) {
        
    }
    @IBAction func Follow_tt(_ sender: UIButton) {
        if let url = URL(string: "http://twitter.com/login"){
        UIApplication.shared.open(url)
        }
    }
    
    @IBAction func Follow_fb(_ sender: UIButton) {
        if let url = URL(string: "http://facebook.com/login"){
        UIApplication.shared.open(url)
        }
    }
 
    @IBAction func passcode(_ sender: UIButton) {
        self.performSegue(withIdentifier: "passcode", sender: self)
    }
   
    @IBAction func Sort(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sort", sender: self)
    }
}
