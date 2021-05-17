//
//  MusicPlayerPresenter.swift
//  music player
//
//  Created by Mac on 28/10/20.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class MusicPlayerPresenter {
    
    let controller: PrivateMusicPlayerRule?
    
    init(controller: PrivateMusicPlayerRule) {
        self.controller = controller
        
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .default, options: .mixWithOthers)
        } catch let error {
            print("AVAudioSession error: \(error)")
        }
        
    }
    
}

extension MusicPlayerPresenter: MusicPlayerPresenterRule {
    func checkState_Seek(state: PlayerState) {
        if state != .Pause {
            self.controller?.doPlay()
        }
    }
    
    func toggle(state: PlayerState) {
        if state != .Stop {
            if state == .Pause {
                self.controller?.doPlay()
            } else {
                self.controller?.doPause()
            }
        }
    }
    
    func checkCurrentItem(item: AVPlayerItem?) {
        if item == nil {
            self.controller?.doReplaceCurrentItem()
        }
    }
    
    
}
