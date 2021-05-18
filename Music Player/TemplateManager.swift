//
//  TemplateManager.swift
//  Music Player
//
//  Created by Mac on 17/05/21.
//

import Foundation
import Foundation
import CarPlay
import Kingfisher

@available(iOS 12.0, *)
class TemplateManager: NSObject {
    
    /// A reference to the CPInterfaceController that passes in after connecting to CarPlay.
    private var carplayInterfaceController: CPInterfaceController?
    
    /// The CarPlay session configuation contains information on restrictions for the specified interface.
    var sessionConfiguration: CPSessionConfiguration!
    
    /// Connects the root template to the CPInterfaceController.
    func connect(_ interfaceController: CPInterfaceController) {
        carplayInterfaceController = interfaceController
//        carplayInterfaceController!.delegate = self
        sessionConfiguration = CPSessionConfiguration(delegate: self)
        
        
        let nowPlaying = CPNowPlayingTemplate.shared
        
        let rate = CPNowPlayingPlaybackRateButton(handler: { _ in
            
        })
        
        let more = CPNowPlayingMoreButton(handler: { _ in
            
        })
        
        let shuffle = CPNowPlayingShuffleButton(handler: { _ in
            
        })
        
        let repeatButton = CPNowPlayingRepeatButton(handler: { _ in
            
        })
        
        let imageButton = CPNowPlayingImageButton(image: #imageLiteral(resourceName: "musicDefault"), handler: { _ in
            
        })
        
        let addLibrary = CPNowPlayingAddToLibraryButton(handler: { _ in
            
        })
        
        let more2 = CPNowPlayingMoreButton(handler: { _ in
            
        })
        
        nowPlaying.updateNowPlayingButtons([rate,more,shuffle,repeatButton,imageButton,addLibrary,more2])
        
        var tabTemplates = [CPTemplate]()
        
        
//        if #available(iOS 14.0, *) {
//            playlistTemp.tabImage = UIImage(systemName: "list.star")
//        } else {
//            // Fallback on earlier versions
//        }
        tabTemplates.append(self.displayHome())
        
        self.carplayInterfaceController!.delegate = self
        if #available(iOS 14.0, *) {
            self.carplayInterfaceController!.setRootTemplate(CPTabBarTemplate(templates: tabTemplates), animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func disconnect() {
        print("Disconnected from CarPlay window.")
    }
    
}

@available(iOS 12.0, *)
extension TemplateManager: CPInterfaceControllerDelegate {
    func templateWillAppear(_ aTemplate: CPTemplate, animated: Bool) {
        print("Template \(aTemplate.classForCoder) will appear.")
    }

    func templateDidAppear(_ aTemplate: CPTemplate, animated: Bool) {
        print("Template \(aTemplate.classForCoder) did appear.")
    }

    func templateWillDisappear(_ aTemplate: CPTemplate, animated: Bool) {
        print("Template \(aTemplate.classForCoder) will disappear.")
    }

    func templateDidDisappear(_ aTemplate: CPTemplate, animated: Bool) {
        print("Template \(aTemplate.classForCoder) did disappear.")
    }
}

@available(iOS 12.0, *)
extension TemplateManager: CPSessionConfigurationDelegate {
    func sessionConfiguration(_ sessionConfiguration: CPSessionConfiguration, limitedUserInterfacesChanged limitedUserInterfaces: CPLimitableUserInterface) {
        print("Limited UI changed: \(limitedUserInterfaces)")
    }
}


extension TemplateManager {
    private func displayHome() -> CPListTemplate {
        var listItems = [CPListTemplateItem]()
        
        var list = [Music]()
        list += Repo.nZk_BestOfVocalWorks2Album
        list += Repo.gallow_ParkestAlbum
        list += Repo.gallow_TooVirginAlbum
        
//        for song in list {
//
//            let aSong = CPListItem(text: song.title, detailText: song.artist)
//            aSong.handler = { item,completion in
//                MusicPlayer.sharedInstance.stop()
//                MusicPlayer.sharedInstance.getInfo(music: song)
//                MusicPlayer.sharedInstance.setSong(url: song.url)
//                MusicPlayer.sharedInstance.play()
//                self.carplayInterfaceController?.pushTemplate(CPNowPlayingTemplate.shared, animated: true, completion: nil)
//                completion()
//            }
//
//            listItems.append(aSong)
//
//        }
        
        let url_contentGallowTooVirgin = URL(string: "https://images-na.ssl-images-amazon.com/images/I/71TP7B9ta0L._SX522_.jpg")
        let url_contentGallowParkers = URL(string: "https://i1.sndcdn.com/artworks-000513975783-35fqbz-t500x500.jpg")
        let url_content_nZk = URL(string: "https://images.genius.com/86bb485f11d08b9afcd9da32504cac18.1000x1000x1.jpg")
        
        let data_contentGallowTooVirgin = try? Data(contentsOf: url_contentGallowTooVirgin!)
        
        let data_contentGallowParkers = try? Data(contentsOf: url_contentGallowParkers!)
        
        let data_content_nZk = try? Data(contentsOf: url_content_nZk!)
        
        let image_contentGallowTooVirgin = (data_contentGallowTooVirgin != nil) ? UIImage(data: data_contentGallowTooVirgin!) : #imageLiteral(resourceName: "musicDefault")
        let image_contentGallowParkers = (data_contentGallowParkers != nil) ? UIImage(data: data_contentGallowParkers!) : #imageLiteral(resourceName: "musicDefault")
        let image_content_nZk = (data_content_nZk != nil) ? UIImage(data: data_content_nZk!) : #imageLiteral(resourceName: "musicDefault")
        
        let row_contentGallowTooVirgin = CPListImageRowItem(text: "Gallow: To Virgint!!", images: [ image_contentGallowTooVirgin ?? #imageLiteral(resourceName: "musicDefault") , image_contentGallowTooVirgin ?? #imageLiteral(resourceName: "musicDefault")])
        row_contentGallowTooVirgin.handler = { item,completion in
            self.carplayInterfaceController?.pushTemplate(self.dispaly_listSong(music: Repo.gallow_TooVirginAlbum, name: "Gallow: To Virgint!!", image: image_contentGallowTooVirgin), animated: true, completion: nil)
            completion()
        }
        
        let row_contentGallowParkers = CPListImageRowItem(text: "Gallow: Parkers", images: [image_contentGallowParkers ?? #imageLiteral(resourceName: "musicDefault") ,image_contentGallowParkers ?? #imageLiteral(resourceName: "musicDefault")])
        row_contentGallowParkers.handler = { item,completion in
            self.carplayInterfaceController?.pushTemplate(self.dispaly_listSong(music: Repo.gallow_ParkestAlbum, name: "Gallow: Parkers", image: image_contentGallowParkers), animated: true, completion: nil)
            completion()
        }
        
        let row_content_nZk = CPListImageRowItem(text: "SawanoHiroyuki[nZk]: BEST OF VOCAL WORKS [nZk] 2", images: [image_content_nZk ?? #imageLiteral(resourceName: "musicDefault") ,image_content_nZk ?? #imageLiteral(resourceName: "musicDefault")])
        row_content_nZk.handler = { item,completion in
            self.carplayInterfaceController?.pushTemplate(self.dispaly_listSong(music: Repo.nZk_BestOfVocalWorks2Album, name: "SawanoHiroyuki[nZk]: BEST OF VOCAL WORKS [nZk] 2", image: image_content_nZk), animated: true, completion: nil)
            completion()
        }
        
        listItems.append(row_contentGallowTooVirgin)
        listItems.append(row_contentGallowParkers)
        listItems.append(row_content_nZk)
        
        
        let playlistTemp = CPListTemplate(title: "Home", sections: [CPListSection(items: listItems)])
        playlistTemp.tabImage = #imageLiteral(resourceName: "home")
        print("CPListTemplate.maximumItemCount: \(CPListTemplate.maximumItemCount)")
        print("CPListTemplate.maximumSectionCount: \(CPListTemplate.maximumSectionCount)")
        return playlistTemp
    }
    
    
    private func dispaly_listSong(music:[Music],name:String,image:UIImage? = nil) -> CPListTemplate {
        var listItems = [CPListTemplateItem]()
        
        for song in music {
            let aSong = CPListItem(text: song.title, detailText: song.artist, image: image)
            aSong.handler = { item,completion in
                MusicPlayer.sharedInstance.stop()
                MusicPlayer.sharedInstance.getInfo(music: song)
                MusicPlayer.sharedInstance.setSong(url: song.url)
                MusicPlayer.sharedInstance.play()
                self.carplayInterfaceController?.pushTemplate(CPNowPlayingTemplate.shared, animated: true, completion: nil)
                completion()
            }
            listItems.append(aSong)

        }
        
        let playlistTemp = CPListTemplate(title: name, sections: [CPListSection(items: listItems)])
        //playlistTemp.tabImage = #imageLiteral(resourceName: "home")
        print("CPListTemplate.maximumItemCount: \(CPListTemplate.maximumItemCount)")
        print("CPListTemplate.maximumSectionCount: \(CPListTemplate.maximumSectionCount)")
        return playlistTemp
        
    }
    
}
