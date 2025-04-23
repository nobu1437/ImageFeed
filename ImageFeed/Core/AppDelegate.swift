//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Andrey Nobu on 25.01.2025.
//

import UIKit
import ProgressHUD

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      ProgressHUD.animationType = .activityIndicator
      ProgressHUD.colorHUD = .black
      ProgressHUD.colorAnimation = .lightGray
      return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      let sceneConfiguration = UISceneConfiguration(          
          name: "Main",
          sessionRole: connectingSceneSession.role
      )
      sceneConfiguration.delegateClass = SceneDelegate.self
      return sceneConfiguration
    }
}

