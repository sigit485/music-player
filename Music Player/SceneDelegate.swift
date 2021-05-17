//
//  SceneDelegate.swift
//  Music Player
//
//  Created by Mac on 17/05/21.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    internal var window: UIWindow?
    lazy var coreData = CoreDataStack(modelName: "Music_Player")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene, session.configuration.name == "SceneConfiguration" else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        let homeVC = HomeViewController()
        homeVC.addCoreDataStack(coreData: coreData)
        let nav = UINavigationController(rootViewController: homeVC)
        nav.isNavigationBarHidden = true

        window?.rootViewController = nav
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        if scene.session.configuration.name == "SceneConfiguration" {
            print("Logger window scene did disconnect.")
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if scene.session.configuration.name == "SceneConfiguration" {
            print("Logger window scene did become active.")
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        if scene.session.configuration.name == "LoggerSceneConfiguration" {
            print("Logger window scene will resign active.")
        }
    }
    
    
}
