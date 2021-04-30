//
//  HomeViewPresenterRule.swift
//  Music Player
//
//  Created by Mac on 20/04/21.
//

import Foundation
import UIKit


protocol HomeViewPresenterRule {
    func setupViewInfo(item:Any) -> NSLayoutConstraint
    func setupEmptyView() -> Bool
    func updateViewInfo()
}

protocol HomeViewMusicPlayerPresenterRule {
    func addQueue(music:[Music])
    func updateQueue()
    func checkState(state:PlayerState)
}
