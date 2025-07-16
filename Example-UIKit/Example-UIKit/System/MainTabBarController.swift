import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Set delegate
    delegate = self

    setupTabs()
    configureTabBarAppearance()
    
    // Only configure sidebar for iOS 18+
    if #available(iOS 18.0, *) {
      configureSidebar()
    }
  }

  private func setupTabs() {
    if #available(iOS 18.0, *) {
      setupTabsModern()
    } else {
      setupTabsLegacy()
    }
  }

  @available(iOS 18.0, *)
  private func setupTabsModern() {
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
      title: "Split View Demos",
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

    // Create additional tabs for demonstration
    let settingsTab = UITab(
      title: "Settings",
      image: UIImage(systemName: "gear"),
      identifier: "settings"
    ) { _ in
      let settingsVC = self.createSettingsViewController()
      let navController = UINavigationController(rootViewController: settingsVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let documentsTab = UITab(
      title: "Documents",
      image: UIImage(systemName: "doc.text"),
      identifier: "documents"
    ) { _ in
      let documentsVC = self.createDocumentsViewController()
      let navController = UINavigationController(rootViewController: documentsVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let favoritesTab = UITab(
      title: "Favorites",
      image: UIImage(systemName: "heart"),
      identifier: "favorites"
    ) { _ in
      let favoritesVC = self.createFavoritesViewController()
      let navController = UINavigationController(rootViewController: favoritesVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    let projectsTab = UITab(
      title: "Projects",
      image: UIImage(systemName: "folder"),
      identifier: "projects"
    ) { _ in
      let projectsVC = self.createProjectsViewController()
      let navController = UINavigationController(rootViewController: projectsVC)
      navController.navigationBar.prefersLargeTitles = true
      return navController
    }

    // Set all tabs
    tabs = [
      homeTab, splitViewDemoTab, aboutTab, settingsTab, documentsTab, favoritesTab, projectsTab,
    ]
  }

  private func setupTabsLegacy() {
    let homeNavController = UINavigationController(rootViewController: HomeViewController())
    homeNavController.navigationBar.prefersLargeTitles = true
    homeNavController.tabBarItem = UITabBarItem(
      title: "Home",
      image: UIImage(systemName: "house"),
      tag: 0
    )

    let splitViewDemoNavController = UINavigationController(rootViewController: SplitViewDemoViewController())
    splitViewDemoNavController.navigationBar.prefersLargeTitles = true
    splitViewDemoNavController.tabBarItem = UITabBarItem(
      title: "Split View Demos",
      image: UIImage(systemName: "rectangle.split.2x1"),
      tag: 1
    )

    let aboutNavController = UINavigationController(rootViewController: AboutViewController())
    aboutNavController.navigationBar.prefersLargeTitles = true
    aboutNavController.tabBarItem = UITabBarItem(
      title: "About",
      image: UIImage(systemName: "info.circle"),
      tag: 2
    )

    let settingsNavController = UINavigationController(rootViewController: createSettingsViewController())
    settingsNavController.navigationBar.prefersLargeTitles = true
    settingsNavController.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(systemName: "gear"),
      tag: 3
    )

    let documentsNavController = UINavigationController(rootViewController: createDocumentsViewController())
    documentsNavController.navigationBar.prefersLargeTitles = true
    documentsNavController.tabBarItem = UITabBarItem(
      title: "Documents",
      image: UIImage(systemName: "doc.text"),
      tag: 4
    )

    let favoritesNavController = UINavigationController(rootViewController: createFavoritesViewController())
    favoritesNavController.navigationBar.prefersLargeTitles = true
    favoritesNavController.tabBarItem = UITabBarItem(
      title: "Favorites",
      image: UIImage(systemName: "heart"),
      tag: 5
    )

    let projectsNavController = UINavigationController(rootViewController: createProjectsViewController())
    projectsNavController.navigationBar.prefersLargeTitles = true
    projectsNavController.tabBarItem = UITabBarItem(
      title: "Projects",
      image: UIImage(systemName: "folder"),
      tag: 6
    )

    // Set all view controllers
    viewControllers = [
      homeNavController,
      splitViewDemoNavController,
      aboutNavController,
      settingsNavController,
      documentsNavController,
      favoritesNavController,
      projectsNavController
    ]
  }

  private func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .systemBackground

    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance
    tabBar.tintColor = .systemBlue
  }

  @available(iOS 18.0, *)
  private func configureSidebar() {
    // Enable sidebar mode
    mode = .tabSidebar

    // Configure sidebar appearance
    sidebar.isHidden = false
  }

  // MARK: - Helper Methods for Creating View Controllers

  private func createSettingsViewController() -> UIViewController {
    let settingsVC = UIViewController()
    settingsVC.title = "Settings"
    settingsVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Settings"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    settingsVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: settingsVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: settingsVC.view.centerYAnchor),
    ])

    return settingsVC
  }

  private func createDocumentsViewController() -> UIViewController {
    let documentsVC = UIViewController()
    documentsVC.title = "Documents"
    documentsVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Documents"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    documentsVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: documentsVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: documentsVC.view.centerYAnchor),
    ])

    return documentsVC
  }

  private func createFavoritesViewController() -> UIViewController {
    let favoritesVC = UIViewController()
    favoritesVC.title = "Favorites"
    favoritesVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Favorites"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    favoritesVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: favoritesVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: favoritesVC.view.centerYAnchor),
    ])

    return favoritesVC
  }

  private func createProjectsViewController() -> UIViewController {
    let projectsVC = UIViewController()
    projectsVC.title = "Projects"
    projectsVC.view.backgroundColor = .systemGroupedBackground

    let label = UILabel()
    label.text = "Projects"
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false

    projectsVC.view.addSubview(label)
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: projectsVC.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: projectsVC.view.centerYAnchor),
    ])

    return projectsVC
  }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {

  func tabBarController(
    _ tabBarController: UITabBarController, shouldSelect viewController: UIViewController
  ) -> Bool {
    return true
  }

  // This method is called when the user customizes the tab bar order
  func tabBarController(
    _ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController],
    changed: Bool
  ) {
    if changed {
      // Update our tabs array to reflect the new order
      // This helps maintain consistency between sidebar and tab bar
      print("Tab order changed - tabs have been reordered")
    }
  }

  // Called when the user interacts with the sidebar (iOS 18+ only)
  @available(iOS 18.0, *)
  func tabBarController(
    _ tabBarController: UITabBarController, sidebar: UITabBarController.Sidebar,
    didSelectTab tab: UITab
  ) {
    // Handle sidebar tab selection
    print("Sidebar tab selected: \(tab.title)")
  }
}
