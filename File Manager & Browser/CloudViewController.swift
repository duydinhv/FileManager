//
//  CloudView.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/13/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

class CloudViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func AddCloud(_ sender: Any) {
        self.performSegue(withIdentifier: "SecondCloudView", sender: self)
    }
}

