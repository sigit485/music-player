//
//  MusicPlayerRule.swift
//  music player
//
//  Created by Mac on 27/10/20.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation
import AVFoundation

enum PlayerState {
    case Playing
    case Pause
    case Seek
    case Stop
    case Loading
    case Ready
}

enum DoOnObserver {
    case RemoveObserver
    case AddObserver
}

protocol PlayerDelegate: class {
    func updateProgresTime(time: Double)
    func updateDuration(time:Double)
    func updateState(state: PlayerState)
    func updateBuffer(second:Double)
}

protocol MusicPlayerRule {
    var playerDelegate: PlayerDelegate? { get set }
    func play()
    func stop()
    func pause()
    func setSong(url:String)
    func seek(timeTo:Double)
    func togglePlayPause()
    func getDuration() -> Double?
    func getTimeElapsed() -> Double?
    func getInfo(music:Music)
    var updateDuration: (() -> ())? {get set}
    var updateTimeElapsed: (() -> ())? {get set}
    var updateState: ((PlayerState) -> ())? {get set}
}

protocol MusicPlayerSetupRule {
    var player: AVPlayer{ get set }
}

protocol MusicPlayerObservable {
    
}

protocol MusicPlayerPresenterRule {
    func checkState_Seek(state: PlayerState)
    func toggle(state: PlayerState)
    func checkCurrentItem(item: AVPlayerItem?)
}

protocol PrivateMusicPlayerRule {
    func doPlay()
    func doPause()
    func doReplaceCurrentItem()
    
}

protocol MusicPlayerObserverRule {
    func registerObserver(item: AVPlayerItem?)
}

protocol PrivateMusicPlayerObserverRule {
    func removeNotification(item:AVPlayerItem)
    func addNotification(item:AVPlayerItem)
    func getLastPlayedItem() -> AVPlayerItem?
    func getTimeObserver() -> Any?
    func setTimeObserver(timeObserver: Any?)
    func setTimeObserver(interval: CMTime)
    func doUpdateDuration(duration: Double)
    func playbackLikelyToKeepUp_loading()
    func playbackLikelyToKeepUp_ready()
    func getPlayerStatus() -> AVPlayer.Status
    func setBufferObserver()
    
}

protocol MusicPlayerObserverPresenterRule {
    func checkPlayerItem(item:AVPlayerItem?,task: DoOnObserver)
    func checkKey(object:Any?,key:String?,playerItem:AVPlayerItem?)
}
