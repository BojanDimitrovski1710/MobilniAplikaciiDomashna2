//
//  SceneDelegate.swift
//  181545-proj
//
//  Created by socd on 11/14/22.
//  Copyright © 2022 BD. All rights reserved.
//

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        let decoder = PropertyListDecoder()
        let data = UserDefaults.standard.data(forKey: "LoginInfo")
        if data != nil{
            // TODO: Implement remember me
        }
        else{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
            navigationController.setViewControllers([loginViewController], animated: false)
        }
        window?.rootViewController = navigationController
    }
    
    
}
