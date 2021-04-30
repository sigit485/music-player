//
//  MusicPlayer.swift
//  music player
//
//  Created by Mac on 27/10/20.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer: NSObject, MusicPlayerSetupRule {
    var player: AVPlayer
    
    fileprivate var playerItem:AVPlayerItem? = nil
    private var isPlaying: PlayerState = .Stop{
        didSet {
            playerDelegate?.updateState(state: isPlaying)
            updateState?(isPlaying)
        }
    }
    
    private var presenter: MusicPlayerPresenterRule?
    
    private var playerObserver: MusicPlayerObserverRule?
    
    private var timeObserver: Any?
    
    private var bufferObserver: Any?
    
    private var lastPlayedItem: AVPlayerItem? = nil
    
    private var presenterObserver: MusicPlayerObserverPresenterRule?
    
    weak var playerDelegate: PlayerDelegate?
    
    static var sharedInstance: MusicPlayerRule = MusicPlayer()
    
    
    var updateDuration: (() -> ())? = nil
    var updateTimeElapsed: (() -> ())? = nil
    var updateState: ((PlayerState) -> ())? = nil
    
    override init() {
        player = AVPlayer()
        super.init()
        presenter = MusicPlayerPresenter(controller: self)
        presenterObserver = MusicPlayerObserverPresenter(controller: self)
        //player = AVPlayer()
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        presenterObserver?.checkKey(object: object, key: keyPath, playerItem: playerItem)
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("keyPath: \(keyPath)")
    }
    
    
}

extension MusicPlayer: MusicPlayerRule {
    func getDuration() -> Double? {
        let duration = player.currentItem?.duration.seconds
        
        return duration
    }
    
    func getTimeElapsed() -> Double? {
        let timeElapsed = player.currentItem?.currentTime().seconds
        
        return timeElapsed
    }
    
    func play() {
        
        self.presenter?.checkCurrentItem(item: player.currentItem)
        
        player.play()
        isPlaying = .Playing
    }
    
    func stop() {
        isPlaying = .Stop
        player.pause()
        player.seek(to: .zero)
    }
    
    func pause() {
        isPlaying = .Pause
        player.pause()
    }
    
    func setSong(url: String) {
        
        let setupUrl = AVURLAsset(url: URL(string: url)!, options: [:])
        
        let songUrl = AVPlayerItem(asset: setupUrl)
        playerItem = songUrl
        playerItem?.preferredForwardBufferDuration = 5
        player = AVPlayer(playerItem: songUrl)
        isPlaying = .Loading
        registerObserver(item: songUrl)
    }
    
    @objc func itemDidPlayToEnd() {
        // tODO:
        stop()
        
        
//        player.seek(to: .zero) { _ in
//            
//        }
    }
    
    func seek(timeTo: Double) {
        
        let seekTime = CMTime(seconds: timeTo, preferredTimescale: 1)
        
        isPlaying = .Seek
        player.pause()
        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .positiveInfinity, completionHandler: { [weak self] result in
            self?.presenter?.checkState_Seek(state: (self?.isPlaying)!)
        })
    }
    
    func togglePlayPause() {
        self.presenter?.toggle(state: isPlaying)
    }
    
    
}

extension MusicPlayer: PrivateMusicPlayerRule {
    func doPlay() {
        self.play()
    }
    
    func doPause() {
        self.pause()
    }
    
    func doReplaceCurrentItem() {
        player.replaceCurrentItem(with: playerItem)
    }
    
    
}

extension MusicPlayer: MusicPlayerObserverRule {
    func registerObserver(item: AVPlayerItem?) {
        presenterObserver?.checkPlayerItem(item: lastPlayedItem, task: .RemoveObserver)
        lastPlayedItem = item
        presenterObserver?.checkPlayerItem(item: item, task: .AddObserver)
    }
    
    
}

extension MusicPlayer: PrivateMusicPlayerObserverRule {
    func getPlayerStatus() -> AVPlayer.Status {
        return player.status
    }
    
    func playbackLikelyToKeepUp_loading() {
        isPlaying = .Loading
    }
    
    func playbackLikelyToKeepUp_ready() {
        isPlaying = .Playing
    }
    
    func removeNotification(item: AVPlayerItem) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: item)
        item.removeObserver(self, forKeyPath: "status")
        item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        item.removeObserver(self, forKeyPath: "duration")
        item.removeObserver(self, forKeyPath: "loadedTimeRanges")
    }
    
    func addNotification(item: AVPlayerItem) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: item)
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "duration", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new], context: nil)
    }
    
    func getLastPlayedItem() -> AVPlayerItem? {
        return lastPlayedItem
    }
    
    func getTimeObserver() -> Any? {
        return timeObserver
    }
    
    func setTimeObserver(timeObserver: Any?) {
        self.timeObserver = timeObserver
    }
    
    func setTimeObserver(interval: CMTime) {
        self.timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { time in
            //do time update
            self.playerDelegate?.updateProgresTime(time: time.seconds)
            self.updateTimeElapsed?()
        })
    }
    
    func setBufferObserver() {
        
        if let bufferValue = player.currentItem?.loadedTimeRanges.last?.timeRangeValue.end.seconds {
            playerDelegate?.updateBuffer(second: bufferValue)
        }
        else {
            print("buffer still empty")
            
            playerDelegate?.updateBuffer(second: 0)
        }
        
        
        
        
    }
    
    func doUpdateDuration(duration: Double) {
        //totalTime
        playerDelegate?.updateDuration(time: duration)
        updateDuration?()
    }
    
}

