import NavigableSplitView
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
      if #available(iOS 18.0, *) {
          window?.rootViewController = MainTabBarController()
      } else {
          window?.rootViewController = NavigableSplitViewController(primary: SidebarContentViewController(), secondary: UIViewController())
      }
    window?.makeKeyAndVisible()
  }
}

private class SidebarViewController2: NavigableSplitViewController {
  
}
