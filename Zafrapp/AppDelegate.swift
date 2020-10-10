//
//  AppDelegate.swift
//  Zafrapp
//
//  Created by Mayte Dominguez Gomez on 5/3/20.
//  Copyright © 2020 Mayte Dominguez Gomez. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = .white
        
        IQKeyboardManager.shared.enable = true
        configureMainViewController()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

private extension AppDelegate {
    func configureMainViewController() {
        if #available(iOS 13.0, *) {
        } else {
            if UserDefaults.standard.bool(forKey: AppConstants.UserDefaults.isSaved.rawValue) {
                window = UIWindow(frame: UIScreen.main.bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "splash", bundle: nil)
                let exampleViewController: AutoLoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "autoLoginVC") as! AutoLoginViewController
                window?.rootViewController = exampleViewController
                window?.makeKeyAndVisible()
            }
        }
    }
}
