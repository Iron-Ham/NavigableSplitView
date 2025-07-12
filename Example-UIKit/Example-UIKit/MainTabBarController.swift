import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabs()
    configureTabBarAppearance()
  }

  private func setupTabs() {
    let homeTab = UITab(
      title: "Home",
      image: UIImage(systemName: "house"),
      identifier: "home"
    ) { _ in
      let navController = UINavigationController(rootViewController: HomeViewController())
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let splitViewDemoTab = UITab(
      title: "Split View",
      image: UIImage(systemName: "rectangle.split.2x1"),
      identifier: "splitView"
    ) { _ in
      let navController = UINavigationController(rootViewController: SplitViewDemoViewController())
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let aboutTab = UITab(
      title: "About",
      image: UIImage(systemName: "info.circle"),
      identifier: "about"
    ) { _ in
      let navController = UINavigationController(rootViewController: AboutViewController())
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    tabs = [homeTab, splitViewDemoTab, aboutTab]
  }

  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground

    tabBar.standardAppearance = appearance
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }

    tabBar.tintColor = .systemBlue
  }
}
