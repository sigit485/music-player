//
//  MusicPlayerViewPresenterRule.swift
//  Music Player
//
//  Created by Mac on 22/04/21.
//

import Foundation
import UIKit

protocol MusicPlayerViewPresenterRule {
    func updateQueue_data()
    func moveNextQueue()
    func movePrevQueue()
    func playPause()
    func seek(value: Float)
    func pause()
    func rotateWhenSeek(oldValue:Float,newValue:Float)
    func closePanelMusicPlayer_WithAnimation(frame:CGRect,isFinish:@escaping (Bool)->())
    func maximizePanelMusicPlayer_withAnimation(frame:CGRect,duration:Double,isFinish: @escaping (Bool)->())
    func minimizePanelMusicPlayer_withAnimation(frame:CGRect,duration:Double,isFinish:@escaping (Bool)->())
    func maximizePanelController(frame:CGRect,animated: Bool, duration: Double, completion: (() -> Void)?)
    func minimizePanelController(frame:CGRect,animated: Bool, duration: Double, completion: (() -> Void)?)
}
