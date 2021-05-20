//
//  HomeViewPresenter.swift
//  Music Player
//
//  Created by Mac on 20/04/21.
//

import Foundation
import UIKit

class HomeViewPresenter {
    
    private var view: HomeViewController? = nil
    private var coreDataMusic: CoreDataMusicProtocol? = nil
    private var queue: Queue? = nil
    private var playWhenClicked: (() ->())? = nil
    
    init(view:HomeViewController) {
        self.view = view
        coreDataMusic = CoreDataMusic()
        queue = Queue(coreData: self.view?.returnCoreDataStack()!)
        //MusicPlayer.sharedInstance.playerDelegate = self
        
        
        playWhenClicked = { [weak self] in
            self?.playFromQueue()
        }
        
        MusicPlayer.sharedInstance.updateState = { [weak self] state in
            if state == .Stop || state == .Pause {
                self?.view?.viewInfo.getButton().setTitle("Play", for: .normal)
            } else{
                self?.view?.viewInfo.getButton().setTitle("Pause", for: .normal)
            }
            
        }
        
    }
    
    
}

extension HomeViewPresenter {
    
}

extension HomeViewPresenter: HomeViewPresenterRule {
    func setupViewInfo(item:Any) -> NSLayoutConstraint {
        
        let isAlreadyShow = UserDefaults.standard.value(forKey: "viewInfo") as? Bool ?? false
        
        if isAlreadyShow == false {
            return NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: self.view?.view!, attribute: .bottom, multiplier: 1, constant: ((self.view?.view!.frame.height)!/9))
        } else {
            return NSLayoutConstraint(item: item, attribute: .bottom, relatedBy: .equal, toItem: self.view?.view!, attribute: .bottom, multiplier: 1, constant: 0)
        }
    }
    
    func setupEmptyView() -> Bool {
        let isAlreadyShow = UserDefaults.standard.value(forKey: "viewInfo") as? Bool ?? false
        
        if isAlreadyShow == false {
            return true
        } else {
            return false
        }
        
    }
    
    func updateViewInfo() {
        let isAlreadyShow = UserDefaults.standard.value(forKey: "viewInfo") as? Bool ?? false
        
        if isAlreadyShow == false {
            
            self.view?.updateConstraints_ViewInfo()
            
        }
    }
    
}

extension HomeViewPresenter: HomeViewMusicPlayerPresenterRule {
    func addQueue(music:[Music]) {
        self.view?.returnCoreDataStack()?.doInBackground(managedContext: { [weak self] context in
            
            self?.coreDataMusic?.deleteAllSong(managedContext: context, success: {
                self?.coreDataMusic?.addAllSong(managedContext: context, musics: music, success: {
                    
                    self?.playWhenClicked?()
                    
                    self?.view?.updateSongInfo?()
                    print("add queue success")
                }, failed: {
                    print("add queue failed")
                })
            }, failed: {
                print("delete queue failed")
            })
        })
    }
    
    func updateQueue() {
        queue?.getPlayedSong(result: { [weak self] result in
            
            guard let music = result else {
                print("failed get now playing")
                return
            }
            
            DispatchQueue.main.async {
                self?.view?.viewInfo.addInfo(music: music)
                //MusicPlayer.sharedInstance.setSong(url: music.url)
                //MusicPlayer.sharedInstance.play()
            }
        })
    }
    
    func playFromQueue() {
        queue?.getPlayedSong(result: { [weak self] result in
            
            guard let music = result else {
                print("failed get now playing")
                return
            }
            
            DispatchQueue.main.async {
                MusicPlayer.sharedInstance.stop()
                MusicPlayer.sharedInstance.getInfo(music: music, image: nil)
                MusicPlayer.sharedInstance.setSong(url: music.url)
                MusicPlayer.sharedInstance.play()
            }
        })
    }
    
    func checkState(state:PlayerState) {
        if state == .Stop || state == .Pause {
            self.view?.viewInfo.getButton().setTitle("Play", for: .normal)
        } else{
            self.view?.viewInfo.getButton().setTitle("Pause", for: .normal)
        }
    }
    
}

extension HomeViewPresenter: PlayerDelegate {
    func updateProgresTime(time: Double) {
        
    }
    
    func updateDuration(time: Double) {
        
    }
    
    func updateState(state: PlayerState) {
        if state == .Stop || state == .Pause {
            self.view?.viewInfo.getButton().setTitle("Play", for: .normal)
        } else{
            self.view?.viewInfo.getButton().setTitle("Pause", for: .normal)
        }
    }
    
    func updateBuffer(second: Double) {
        
    }
    
    
}
