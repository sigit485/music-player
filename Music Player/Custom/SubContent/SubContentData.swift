//
//  SubContentData.swift
//  Music Player
//
//  Created by Mac on 13/04/21.
//

import Foundation
import UIKit
import Kingfisher

class SubContentData: NSObject {
    
    private var view: SubContent? = nil
    
    
    override init() {
        
    }
    
    convenience init(view:SubContent) {
        self.init()
        self.view = view
        self.view?.getCollection().register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "itemCell")
        self.view?.getCollection().delegate = self
        self.view?.getCollection().dataSource = self
    }
    
}

extension SubContentData: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.view?.getContent() {
            return data.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let data = self.view?.getContent()[indexPath.item] {
            cell.addData(music: data)
        } else {
            return UICollectionViewCell()
        }
        
        if let url = self.view?.getImageURL() , url != "" {
            cell.setImage(url: url)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.view?.clickedSong?(self.view?.getContent()[indexPath.item])
        
        guard var data = self.view?.getContent() else {
            return
        }
        
        let element = data.remove(at: indexPath.item)
        data.insert(element, at: 0)
        
        self.view?.clickedSong?(data)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else {
            return
        }
        
        cell.returnImageArtist_Property().kf.cancelDownloadTask()
        
    }
    
    
}

extension SubContentData: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("frame width: \(self.view?.frame.width)")
        
        return CGSize(width: ((self.view!.frame.width) / 2), height: (self.view!.frame.height - 70))
    }
    
    
    
}



