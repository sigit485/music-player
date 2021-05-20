//
//  MediaCommandCenter.swift
//  Music Player
//
//  Created by Mac on 17/05/21.
//

import Foundation
import MediaPlayer

protocol MediaCommandCenterDelegate: class {
    func didNextTrack()
    func didPreviousTrack()
    func didPause()
    func didPlay()
    func didTogglePlayPause()
}

class MediaCommandCenter: NSObject {
    fileprivate let controlCenter: MPRemoteCommandCenter
    fileprivate var cacheMediaPlayerInfo: [String:Any]
    fileprivate var nowMediaPlayerInfoCenter: MPNowPlayingInfoCenter
    weak var delegate: MediaCommandCenterDelegate?
    
    override init() {
        controlCenter = MPRemoteCommandCenter.shared().self
        cacheMediaPlayerInfo = [:]
        nowMediaPlayerInfoCenter = MPNowPlayingInfoCenter.default().self
        super.init()
        setupControlCenter()
    }
    
    private func setupControlCenter() {
        controlCenter.previousTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.delegate?.didPreviousTrack()
            return .success
        }
        controlCenter.nextTrackCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.delegate?.didNextTrack()
            return .success
        }
        controlCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.delegate?.didPause()
            return .success
        }
        controlCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.delegate?.didPlay()
            return .success
        }
        controlCenter.togglePlayPauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.delegate?.didTogglePlayPause()
            return .success
        }
    }
}

extension MediaCommandCenter {
    func setMediaPlayerInfo(song:Music) {
        setMediaPlayerInfo(song: song, image: nil)
        if #available(iOS 13, *) {
            MPNowPlayingInfoCenter.default().playbackState = .playing
        }
    }
    
    
    func setMediaPlayerInfo(song: Music, image: UIImage?) {
        // Reset state if previous song is different than the next song
        if song.title != cacheMediaPlayerInfo[MPMediaItemPropertyTitle] as? String &&
            song.artist != cacheMediaPlayerInfo[MPMediaItemPropertyArtist] as? String {
            reset()
        }
        
        let mediaPlayerInfo = getMediaPlayerInfo(song: song, coverImage: image)
        configureMediaPlayerInfo(mediaPlayerInfo: mediaPlayerInfo)
    }
    
    
    func updatePlayback(currentProgress: Float,expectedDuration: Float){
        //var newMusicProgress = musicProgress
        let progress = currentProgress
        let duration = expectedDuration
        
        self.cacheMediaPlayerInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] =  NSNumber(value: progress)
        let currentDuration = cacheMediaPlayerInfo[MPMediaItemPropertyPlaybackDuration] as? Float
        if currentDuration != duration {
            cacheMediaPlayerInfo[MPMediaItemPropertyPlaybackDuration] =  duration
        }
        configureMediaPlayerInfo(mediaPlayerInfo: cacheMediaPlayerInfo)
    }
}

extension MediaCommandCenter {
    
    fileprivate func getMediaPlayerInfo(song: Music, coverImage: UIImage?) -> [String:Any] {
        var mediaInfo:[String:Any] =  [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPMediaItemPropertyAlbumTitle: song.album,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0 as Float),
            ]
        if let image = coverImage {
            mediaInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (newSize) -> UIImage in
                return image.resizeImage(size: newSize)
            })
        }
        return mediaInfo
    }
    
    func reset() {
        nowMediaPlayerInfoCenter.nowPlayingInfo = [
            MPMediaItemPropertyTitle: "",
            MPMediaItemPropertyArtist: "",
            MPMediaItemPropertyAlbumTitle: "",
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0 as Float)
        ]
    }
    
    fileprivate func configureMediaPlayerInfo(mediaPlayerInfo: [String:Any]) {
        cacheMediaPlayerInfo = mediaPlayerInfo
        nowMediaPlayerInfoCenter.nowPlayingInfo = mediaPlayerInfo
    }
}
