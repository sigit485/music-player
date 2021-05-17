//
//  TemplateManager.swift
//  Music Player
//
//  Created by Mac on 17/05/21.
//

import Foundation
import Foundation
import CarPlay

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
        var listItems = [CPListItem]()
        
        
        for song in Repo.gallow_ParkestAlbum {
            
            let aSong = CPListItem(text: song.title, detailText: song.artist)
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
        
        
        let playlistTemp = CPListTemplate(title: "Home", sections: [CPListSection(items: listItems)])
        return playlistTemp
    }
}
