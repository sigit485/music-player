//
//  TemplateApplicationSceneDelegate.swift
//  Music Player
//
//  Created by Mac on 17/05/21.
//

import Foundation
import CarPlay
import UIKit

@available(iOS 12.0, *)
class TemplateApplicationSceneDelegate: NSObject {
    let templateManager = TemplateManager()
    
    
    // MARK: UISceneDelegate
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            if scene is CPTemplateApplicationScene, session.configuration.name == "TemplateSceneConfiguration" {
                print("Template application scene will connect.")
            }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        if scene.session.configuration.name == "TemplateSceneConfiguration" {
            print("Template application scene did disconnect.")
        }
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        if scene.session.configuration.name == "TemplateSceneConfiguration" {
            print("Template application scene did become active.")
        }
    }
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        if scene.session.configuration.name == "TemplateSceneConfiguration" {
            print("Template application scene will resign active.")
        }
    }
    
}

// MARK: CPTemplateApplicationSceneDelegate

@available(iOS 12.0, *)
extension TemplateApplicationSceneDelegate: CPTemplateApplicationSceneDelegate {
    
    @available(iOS 13.0, *)
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
        print("Template application scene did connect.")
        templateManager.connect(interfaceController)
    }
    
    @available(iOS 13.0, *)
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene,
                                  didDisconnectInterfaceController interfaceController: CPInterfaceController) {
        templateManager.disconnect()
        print("Template application scene did disconnect.")
    }
}
