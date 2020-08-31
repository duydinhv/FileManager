//
//  FileCell.swift
//  File Manager & Browser
//
//  Created by DUY on 8/28/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

class FileCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FileCell.self)

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    func update(with file: File) {
        nameLabel.text = file.name
        
        file.generateThumbnail { [weak self] image in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        }
    }
}
