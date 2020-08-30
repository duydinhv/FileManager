//
//  SettingController.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/13/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

class SecondCloudView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func iCloudDrive_Btn(_ sender: Any) {
        if let url = URL(string: "http://google.com"){
        UIApplication.shared.open(url)    }
    }
   @IBAction func Dropbox_Btn(_ sender: Any) {
        if let url = URL(string: "http://dropbox.com"){
        UIApplication.shared.open(url)
    }
    }
    @IBAction func WebDAV_Btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func FTP_Btn(_ sender: Any) {
        self.performSegue(withIdentifier: "FTP", sender: self)
    
    }
    
    @IBAction func Box_Btn(_ sender: Any) {
        if let url = URL(string: "http://account.box.com/login"){
        UIApplication.shared.open(url)
        }
    }
    
    @IBAction func MicrosoftOD_Btn(_ sender: Any) {
        if let url = URL(string: "http://login.microsoftonline.com"){
        UIApplication.shared.open(url)
        }
    }
    @IBAction func GoogleDrive_Btn(_ sender: Any) {
        if let url = URL(string: "http://accounts.google.com"){
        UIApplication.shared.open(url)
        }
        }
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
