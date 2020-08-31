//
//  SecondViewController.swift
//  File Manager & Browser
//
//  Created by HoangDo on 8/11/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var favoriteFiles = [File]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        File.files.forEach { file in
            if file.isFavorite == true {
                if !favoriteFiles.contains(file) {
                    favoriteFiles.append(file)
                }
            }
        }
        
        self.collectionView.reloadData()
    }
}

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCell.reuseIdentifier, for: indexPath) as? FileCell
            else {
                return UICollectionViewCell()
        }
        cell.update(with: favoriteFiles[indexPath.row])
        return cell
    }
    
    
}
