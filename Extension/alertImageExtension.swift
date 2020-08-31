//
//  alertImageExtension.swift
//  File Manager & Browser
//
//  Created by DUY on 8/31/20.
//  Copyright © 2020 HoangDo. All rights reserved.
//

import UIKit

extension UIAlertController {
    func addImage(image: UIImage) {
        let maxSize = CGSize(width: 300, height: 300)
        let imageSize = image.size
        var ratio: CGFloat!
        
        if (imageSize.width > imageSize.height) {
            ratio = maxSize.width / imageSize.width
        } else {
            ratio = maxSize.height / imageSize.height
        }
        
        let scaleSize = CGSize(width: imageSize.width * ratio, height: imageSize.height * ratio)
        
        var resizedImage = image.imageWithSize(scaleSize)
        
        if (imageSize.height > imageSize.width) {
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0))
        }
        
        let imageAction = UIAlertAction(title: nil, style: .default, handler: nil)
        
        imageAction.isEnabled = false
        imageAction.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
        
        self.addAction(imageAction)
    }
}
