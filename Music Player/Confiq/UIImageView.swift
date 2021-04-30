//
//  UIImageView.swift
//  Music Player
//
//  Created by Mac on 15/04/21.
//

import Foundation
import UIKit
import Kingfisher


extension UIImageView {
    func setImage(url:String,times:Int = 3) {
        
        image = nil
        
        guard let getURL = URL(string: url) else {
            return
        }
        
        let placeholder = #imageLiteral(resourceName: "musicDefault")
        let imageResource = ImageResource(downloadURL: getURL, cacheKey: url)
        
        
        let task = KingfisherManager.shared.retrieveImage(with: imageResource , options: [
            .processor(DownsamplingImageProcessor(size: self.frame.size)),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage
        ]) { result in
            switch result{
            case .success(let value):
                print("cache success : \(url)")
            case .failure(let error):
                print("cache failed : \(error.localizedDescription) url : \(url)")
            }
        }
        
        //start
        ImageClassManager.sharedInstance.initialize().retrieveImage(forKey:"\(url)", options: [
            .transition(.fade(10.0)),
            .loadDiskFileSynchronously,
            .forceTransition
        ]){[weak self] result in
            switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self?.contentMode = .scaleAspectFill
                        if value.cacheType == .disk{
                            //self?.image = ThemeManager.shared.songPlaceholder
                            print("cache local type \(value.cacheType) url:  \(url)")
                            task?.cancel()
                            if let cacheImage = value.image{
                                self?.image = cacheImage
                            }
                            else{
                                self?.image = #imageLiteral(resourceName: "musicDefault")
                            }
                            
                        }
                        else{
                            print("cache local type \(value.cacheType) url: \(url)")
                            self?.image = #imageLiteral(resourceName: "musicDefault")
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if times > 0 {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            self?.image = #imageLiteral(resourceName: "musicDefault")
                        })
                        self?.setImage(url: url, times: times - 1)
                    } else {
                        print("failed to download song url: \(url)")
                    }
                }
            }
        //end
        
    }
}


class ImageClassManager{
    private var cache:ImageCache?
    
    static let sharedInstance = ImageClassManager()
    
    
    func initialize() -> ImageCache{
        if let checkInitialize = cache{
            return checkInitialize
        }
        else{
            let setupCache = ImageCache.default
            //setupCache.memoryStorage.config.countLimit = 1000 * 1024 * 1024
            setupCache.memoryStorage.config.totalCostLimit = 1
            setupCache.diskStorage.config.expiration = .days(3)
//            setupCache.calculateDiskStorageSize(completion: {result in
//
//            })
            self.cache = setupCache
            
            return self.cache!
        }
    }
}

