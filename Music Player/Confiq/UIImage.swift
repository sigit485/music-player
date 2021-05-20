//
//  UIImage.swift
//  Music Player
//
//  Created by CODE on 5/20/21.
//

import UIKit

extension UIImage {
    func resizeImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
}
