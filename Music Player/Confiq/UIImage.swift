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
    
    func fromData(url: URL) -> UIImage {
        
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            debugPrint("Error convert images URL to Data \(error)")
            return UIImage()
        }
    
    }
}
