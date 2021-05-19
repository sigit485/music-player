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
    
    let albumImageCollection = [URL(string: "https://images-na.ssl-images-amazon.com/images/I/71TP7B9ta0L._SX522_.jpg"), URL(string: "https://i1.sndcdn.com/artworks-000513975783-35fqbz-t500x500.jpg"), URL(string: "https://images.genius.com/86bb485f11d08b9afcd9da32504cac18.1000x1000x1.jpg")]
    
    let titleAlbumCollection = ["Gallow: To Virgint!!", "Gallow: Parkers", "SawanoHiroyuki[nZk]: BEST OF VOCAL WORKS [nZk] 2"]
    
    let albums = [Repo.gallow_TooVirginAlbum, Repo.gallow_ParkestAlbum, Repo.nZk_BestOfVocalWorks2Album]
    
    /// Connects the root template to the CPInterfaceController.
    func connect(_ interfaceController: CPInterfaceController) {
        carplayInterfaceController = interfaceController
//        carplayInterfaceController!.delegate = self
        sessionConfiguration = CPSessionConfiguration(delegate: self)
        
        
        let nowPlaying = CPNowPlayingTemplate.shared
        nowPlaying.add(self)
        
        nowPlaying.isAlbumArtistButtonEnabled = true
        nowPlaying.isUpNextButtonEnabled = true
        nowPlaying.upNextTitle = "Option"
        
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

extension TemplateManager: CPNowPlayingTemplateObserver {
    func nowPlayingTemplateUpNextButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {
        print("option is tapped")
    }
    
    func nowPlayingTemplateAlbumArtistButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {
        print("title album is tapped")
    }
}


extension TemplateManager {
    private func displayHome() -> CPListTemplate {
        
        var listItems = [CPListTemplateItem]()
        var listRowItems = CPListImageRowItem()
            
        
        for (index, dataImage) in albumImageCollection.enumerated() {
            
            var data = Data()
            
            do {
                data = try Data(contentsOf: dataImage!)
            } catch {
                debugPrint("Error convert images URL to Data \(error)")
            }
            
            let imageTemp = UIImage(data: data) ?? #imageLiteral(resourceName: "musicDefault")
            listRowItems = CPListImageRowItem(text: titleAlbumCollection[index], images: [imageTemp])
            
            listRowItems.handler = { item, completion in
                
                self.carplayInterfaceController?.pushTemplate(self.dispaly_listSong(music: self.albums[index], name: self.titleAlbumCollection[index], image: imageTemp), animated: true, completion: nil)
                completion()
                
            }
            
            listItems.append(listRowItems)
        }
        
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
