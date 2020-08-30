//
//  SecondViewController.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/11/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var fileUrls: [URL] = []
    var allFile = File.loadFiles()
    var files = [File]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.collectionView.reloadData()
        print("count \(files.count)")
    }
}

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCell.reuseIdentifier, for: indexPath) as? FileCell
            else {
                return UICollectionViewCell()
        }
        cell.update(with: files[indexPath.row])
        return cell
    }
    
    
}
