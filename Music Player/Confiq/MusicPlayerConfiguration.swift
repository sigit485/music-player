//
//  MusicPlayerConfiguration.swift
//  Music Player
//
//  Created by Mac on 15/04/21.
//

import Foundation
enum MusicPlayerViewControllerPanelState {
    case isMaximize
    case isMinimize
    case isClosed
}

enum MusicPlayerViewControllerPanelIntiateState {
    case none
    case willClosing
    case willInitiating
    case closed
    case initiated
}

protocol MusicPlayerViewControllerPanelProtocol {
    func maximizePanelController(animated: Bool, duration: Double, completion: (() -> Void)?)
    func minimizePanelController(animated: Bool, duration: Double, completion: (() -> Void)?)
    func closePanelController(animated: Bool, completion: (() -> Void)?)
    func initiatePanelController(animated: Bool, completion: (() -> Void)?)
    func setHiddenPanelView(_ willHidden: Bool)
    func getVisibilityState() -> MusicPlayerViewControllerPanelState
}
