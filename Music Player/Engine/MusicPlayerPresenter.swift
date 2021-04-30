//
//  MusicPlayerPresenter.swift
//  music player
//
//  Created by Mac on 28/10/20.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayerPresenter {
    
    let controller: PrivateMusicPlayerRule?
    
    init(controller: PrivateMusicPlayerRule) {
        self.controller = controller
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
