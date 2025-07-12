//
//  SceneDelegate.swift
//  Example-UIKit
//
//  Created by Hesham Salman on 7/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let mainTabBarController = MainTabBarController()
    window?.rootViewController = mainTabBarController
    window?.makeKeyAndVisible()
  }
}
