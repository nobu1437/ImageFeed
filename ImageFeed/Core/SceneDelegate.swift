//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Andrey Nobu on 25.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      guard let scene = scene as? UIWindowScene else { return }
      window = UIWindow(windowScene: scene)                   // 1
      window?.rootViewController = SplashViewController()
      window?.makeKeyAndVisible()
    }
}

