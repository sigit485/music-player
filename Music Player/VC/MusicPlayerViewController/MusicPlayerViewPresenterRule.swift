//
//  MusicPlayerViewPresenterRule.swift
//  Music Player
//
//  Created by Mac on 22/04/21.
//

import Foundation


protocol MusicPlayerViewPresenterRule {
    func updateQueue_data()
    func moveNextQueue()
    func movePrevQueue()
    func playPause()
    func seek(value: Float)
    func pause()
    func rotateWhenSeek(oldValue:Float,newValue:Float)
}
